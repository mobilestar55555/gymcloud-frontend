define [
  './model'
  './preload'
  'deps/vendor/js.cookie'
], (
  CurrentUser
  preload
  Cookies
) ->

  class Module


    constructor: (@app) ->
      @app.on 'before:start', =>
        @_initTokenHandlers()
        @_initUserHandlers()

      @app.on 'start', ->
        @request('current_user:reset')

    _initTokenHandlers: ->

      @app.reqres.setHandlers

        'auth:isAuthorized': =>
          !!@app.request('accessToken:get')

        'auth:isAuthorizedAs': (permission) =>
          return false unless @app.request('auth:isAuthorized')
          user = @app.request('current_user')
          isPro = user.get('is_pro')

          permission is 'trainer' and isPro ||
          permission is 'client' and !isPro

        'accessToken:set': (token) ->
          Cookies.set('logged', true, {domain: 'gymcloud.com'})
          window.localStorage.setItem('accessToken', token)

        'accessToken:get': ->
          window.localStorage.getItem('accessToken')

        'accessToken:remove': ->
          Cookies.set('logged', false, {domain: 'gymcloud.com'})
          window.localStorage.removeItem('current_user')
          window.localStorage.removeItem('accessToken')

        'auth:onSuccess': (data) =>
          defer = new $.Deferred
          @app.request('accessToken:set', data.access_token)
          user = @app.request('current_user')
          if data?.user
            user.set(user.parse(data.user))
            @_cacheCurrentUser(data.user)

          return if @app.request('check:trial')
          @app.vent.trigger('mixpanel:sign_in')

          @app.request('current_user:init:collections')
            .then =>
              @app.vent.trigger('redirect:to', '#')
              settings = user.user_settings
              if user.get('is_pro') and !settings.get('is_presets_loaded')
                @app.request('base:accountTypes')
            .then(defer.resolve)

          defer.promise()

    _initUserHandlers: ->
      @app.reqres.setHandlers

        'current_user:reset': =>
          @app.data.current_user = user = new CurrentUser
          user.listenTo(user, 'sync', => @_cacheCurrentUser(user.toJSON()))

        'current_user': =>
          @app.data.current_user

        'current_user_id': =>
          @app.request('current_user').get('id')

        'current_user:init:user': @_initUser

        'current_user:init:collections': @_initUserCollections

        'current_user:init:timezone': @_initUserTimezone

    _getCurrentUserFromCache: ->
      json = window.localStorage.getItem('current_user')
      return JSON.parse(json) if json
      {}

    _cacheCurrentUser: (attrs) ->
      window.localStorage.setItem('current_user', JSON.stringify(attrs))

    _initUser: =>
      defer = new $.Deferred
      if @app.request('accessToken:get')
        user = @app.request('current_user')
        user.set(user.parse(@_getCurrentUserFromCache()))
        user.fetch()
          .then(defer.resolve)
          .fail(defer.reject)
          .done ->
            App.listenToOnce App, 'started', ->
              setTimeout ->
                App.vent.trigger('mixpanel:identify')
              , 2000
      else
        defer.reject()
      defer.fail (xhr) =>
        customErrors = [402, 452, 453, 454, 455, 456, 457, 458]
        if _.include(customErrors, xhr?.status)
          token = @app.request('accessToken:get')
          setTimeout((=> @app.request('accessToken:set', token)), 1000)

        @app.request('accessToken:remove')
      defer.promise()

    _initUserCollections: =>
      defer = new $.Deferred
      user = @app.request('current_user')
      dfds = preload(user)
      $.when(dfds...)
        .then(@_initUserTimezone)
        .then(defer.resolve)
      defer.promise()

    _initUserTimezone: =>
      user = @app.request('current_user')
      timezone = user.user_profile.get('timezone')
      if !timezone || timezone in ['0', '1']
        timezone = moment.tz.guess()
        user.user_profile.save({timezone: timezone}, {patch: true})
      moment.tz.setDefault(timezone)
      timezone
