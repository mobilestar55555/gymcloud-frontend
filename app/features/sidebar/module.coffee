define [
  './view'
], (
  SidebarView
) ->

  class Module

    constructor: (@app) ->
      @app.on 'start', =>
        @_initVentListeners()

    _initVentListeners: ->
      @app.listenTo(@app.vent, 'app:layouts:main:render', @_renderSidebarView)

    _renderSidebarView: ->
      view = new SidebarView
      @request 'views:show', view,
        layout: 'main'
        region: 'menu'
