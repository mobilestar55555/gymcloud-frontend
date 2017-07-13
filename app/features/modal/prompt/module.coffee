define [
  './view'
], (
  ModalPromptView
) ->

  class Module

    constructor: (@app) ->
      @app.on 'start', =>
        @_initHandlers()

    _initHandlers: ->
      @app.reqres.setHandler('modal:prompt', @_initModal)

    _initModal: (data) =>
      view = new ModalPromptView(data)
      region = App.request('app:layouts:base').getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      @app.listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()
