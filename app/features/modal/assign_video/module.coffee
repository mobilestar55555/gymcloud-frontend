define [
  './view'
], (
  WorkoutVideoAssignView
) ->

  class Module

    constructor: (@app) ->
      @app.on 'start', =>
        @_initHandlers()

    _initHandlers: ->
      @app.reqres.setHandler('modal:video:assign', @_initModal)
      @app.listenTo(@app.vent, 'modal:video:close', _.bind(@_closeModal, @))

    _initModal: (model, options) =>
      view = new WorkoutVideoAssignView
        model: model
        type: 'modal'
        instantSave: options?.instantSave
      @region = App.request('app:layouts:base').getRegion('modal')
      @region.show(view)
      @region.$el.modal('show')

    _closeModal: ->
      @region.$el.modal('hide')
      @region.currentView?.destroy?()
      @region.destroy()
