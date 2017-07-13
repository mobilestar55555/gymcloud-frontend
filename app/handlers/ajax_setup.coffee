define ->

  (App, config) ->

    errorHandlersObject =
      _showError: (jqxhr) ->
        error = jqxhr.responseJSON.error
        error = error.join(', ') if _.isArray(error)
        message = error.replace( /\s+(\[.+\])/, '')
        App.request('messenger:explain', 'message.error', message: message)
      401: ->
        App.request('accessToken:remove')
        if 'login' is Backbone.history.fragment
          App.request('messenger:explain', 'login.unauthorized')
        else
          App.vent.trigger('redirect:to', ['login'])
      403: (jqxhr) ->
        errorHandlersObject._showError(jqxhr)
      500: (jqxhr) ->
        errorHandlersObject._showError(jqxhr)
      452: ->
        App.vent.trigger('redirect:to', ['auth', 'waiting_gymcloud_pro'])
      453: ->
        App.vent.trigger('redirect:to', ['auth', 'pro_invite_reminder'])
      454: ->
        App.vent.trigger('redirect:to', ['auth', 'find_a_pro'])
      455: ->
        App.vent.trigger('redirect:to', ['auth', 'certificate_required'])
      456: ->
        App.request('current_user').set(email: jqxhr.responseJSON.error.email)
        App.vent.trigger('redirect:to', ['auth', 'confirm_account'])
      457: ->
        App.vent.trigger('redirect:to', ['auth', 'training_plan'])
      458: ->
        App.vent.trigger('redirect:to', ['auth', 'client_assessment'])

    $(document).ajaxStart ->
      App.vent.trigger('ajax:start', arguments...)

    $(document).ajaxComplete ->
      App.vent.trigger('ajax:complete', arguments...)

    $(document).ajaxError (event, jqxhr, settings, thrownError) ->
      func = errorHandlersObject[jqxhr.status]
      func?(jqxhr)

    _.each ['Model', 'Collection'], (namespace) ->
      oldCtr = Backbone[namespace]
      Backbone[namespace]::constructor = ->
        @listenTo @, 'request', ->
          @_isRequested = true
        @listenTo @, 'sync', ->
          @_isRequested = false
          @_isSynced = true
        oldCtr.apply(@, arguments)

    Backbone.originalSync = Backbone.sync
    Backbone.sync = (method, model, options) ->
      options.type = 'PATCH' if method == 'update'
      Backbone.originalSync method, model, options

    $.ajaxSetup
      headers: {'X-Requested-With': 'XMLHttpRequest'}
      contentType: 'application/json'
      crossDomain: true
      xhrFields: withCredentials: true
      beforeSend: (xhr, options) ->
        xhr.withCredentials = true
        options.url = "#{config.api.url}#{options.url}"
        accessToken = App.request('accessToken:get')
        if accessToken
          authorization = "Bearer #{accessToken}"
          xhr.setRequestHeader('Authorization', authorization)
        return
