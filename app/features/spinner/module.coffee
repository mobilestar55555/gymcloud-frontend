define [
  './view'
], (
  SpinnerView
) ->

  class Module

    constructor: (@app) ->
      @_initRegion()
      @_initSpinner()
      @_initHandlers()
      @app

    _initRegion: ->
      @app.baseView.addRegions
        spinnerRegion: 'region[data-name="spinner"]'

    _initSpinner: ->
      @spinner = new SpinnerView

    _initHandlers: ->
      @app.listenTo @app.vent, 'spinner:start', =>
        @spinner.trigger('start')
      @app.listenTo @app.vent, 'spinner:stop', =>
        @spinner.trigger('stop')
      @app.listenTo @app, 'start', =>
        @_initAjax()
      @app.listenTo @app, 'start', =>
        @_showView()
        @spinner.trigger('start')
      @app.listenTo @app, 'started', =>
        setTimeout =>
          @spinner.trigger('stop')
        , 500

    _initAjax: =>
      @app.listenTo @app.vent, 'ajax:start', =>
        @app.vent.trigger('spinner:start')
      @app.listenTo @app.vent, 'ajax:complete', =>
        setTimeout =>
          if $.active is 0
            @app.vent.trigger('spinner:stop')
        , 100

    _showView: ->
      @app.baseView.showChildView('spinnerRegion', @spinner)
