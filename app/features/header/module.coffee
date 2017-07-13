define [
  './view'
], (
  HeaderView
) ->

  class Module

    constructor: (@app) ->
      @app.on 'start', =>
        @_initVentListeners()

    _initVentListeners: ->
      @app.listenTo(@app.vent, 'app:layouts:main:render', @_renderHeaderView)

    _renderHeaderView: ->
      view = new HeaderView

      @request 'views:show', view,
        layout: 'main'
        region: 'header'
