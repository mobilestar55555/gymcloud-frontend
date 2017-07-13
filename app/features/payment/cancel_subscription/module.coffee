define [
  './view'
], (
  View
) ->

  class Module

    constructor: (@app) ->
      @app.on('start', @_initHandlers)

    _initHandlers: =>
      @app.reqres.setHandler('modal:subscription:cancel', @_initModal)

    _initModal: (type = 'add_client') =>
      view = new View
      @region = App.request('app:layouts:base').getRegion('modal')
      @region.show(view)
      @region.$el.modal('show')
