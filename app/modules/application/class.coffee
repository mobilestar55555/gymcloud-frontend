define [
  'marionette'
  './initializers'
  './modules'
  'features/layouts/base/view'
  'modules/utils/hotjar'
  'modules/utils/mixpanel/module'
], (
  Marionette
  initializers
  modules
  BaseLayoutView
  hotjar
  mixpanel
) ->
  handlers = {}

  class Application extends Marionette.Application

    constructor: ->
      @_initV2Channel()
      super

    execute: ->
      @commands.execute.apply(@commands, arguments)

    _initV2Channel: ->
      @channelName = _.result(@, 'channelName') or 'global'
      @channel ||= Backbone.Radio.channel(@channelName)
      @vent = @channel
      @commands = @channel
      channelOn = @channel.on

      @channel.on = ->
        channelOn.apply(@, arguments)

      channelRequest = @channel.request

      @channel.request = ->
        channelRequest.apply(@, arguments)

      @channel.execute = ->
        channelRequest.apply(@, arguments)

      listenTo = Marionette.Object.listenTo

      Marionette.Object.listenTo = (obj) ->
        listenTo.apply(@, arguments)
        return

      return

    initialize: ->
      @listenTo(@, 'before:start', -> initializers(@))
      @listenTo(@, 'start', @_onStarted)

    start: ->
      super unless @_isStarted

    # vent: _.extend({}, Backbone.Events)

    reqres:
      setHandler: (name, func) ->
        handlers[name] = func
      setHandlers: (handlers) ->
        _.each handlers, (value, key) ->
          App.reqres.setHandler(key, value)
      hasHandler: (name) ->
        !!handlers[name]

    request: (name, params...) ->
      return handlers[name](params...) if @reqres.hasHandler(name)
      "handler is not defined - #{name}"

    onBeforeStart: ->
      @_initPromises()
      @_initLayout()
        .done(@promises.layout.resolve)
      @_initModules()
        .done(@promises.modules.resolve)

    onStart: ->
      defer = new $.Deferred

      @promises.modules
        .done =>
          userPromise = @request('current_user:init:user')
          if @request('current_user_id')
            @request('current_user:init:collections')
              .always(@promises.collections.resolve)
          else
            userPromise.then( =>
              @request('current_user:init:collections')
                .always(@promises.collections.resolve)
            )
          userPromise.fail(@promises.collections.resolve)
            .always(@promises.user.resolve)

      dfds = _.values(@promises)
      $.when(dfds...).done =>
        @_initHistory()
        return if @request('check:trial')
        @_openProgramPresetsLoader()
        defer.resolve()

      defer.done =>
        @_isStarted = true
        @trigger('started')

      defer.promise()

    _onStarted: ->
      feature.isEnabled('hotjar') && hotjar.init()
      feature.isEnabled('mixpanel') && mixpanel.init()

    _initPromises: ->
      names = [
        'modules'
        'layout'
        'user'
        'collections'
      ]
      @promises = _.reduce names, (memo, name) ->
        memo[name] = new $.Deferred
        memo
      , {}

    _initModules: ->
      defer = new $.Deferred
      modules(@)
      setTimeout ->
        defer.resolve()
      , 50
      defer.promise()

    _initLayout: ->
      defer = new $.Deferred
      @baseView = new BaseLayoutView
      @baseView.once('render', defer.resolve)
      @baseView.render()
      defer.promise()

    _changeLocaltionHash: ->
      if not @request('current_user_id')
        path = window.location.hash
          .match(/^\#\/?(.*)$/)?[1] || ''
        exclusions = [
          /login/
          /signup/
          /reset/
          /prototype\/ui/
          /accessToken/
        ]
        exclusion = _.any exclusions, (rule) ->
          path.match(rule)
        unless exclusion
          window.location.replace('#login')

    _initHistory: ->
      @_changeLocaltionHash()
      @_startHistory()

    _startHistory: ->
      Backbone.history.start()

    _openProgramPresetsLoader: ->
      user = @request('current_user')
      settings = user.user_settings
      if user.get('is_pro') and !settings.get('is_presets_loaded')
        @request('base:accountTypes')
