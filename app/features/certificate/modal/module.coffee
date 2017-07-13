define [
  './view'
], (
  CertificateUploadModalView
) ->

  class Module

    constructor: (@app) ->
      @app.on('start', @_initHandlers)

    _initHandlers: =>
      @app.reqres.setHandler('modal:certificate:upload', @_initModal)

    _initModal: (type = 'add_client') =>
      view = new CertificateUploadModalView(type: type)
      @region = App.request('app:layouts:base').getRegion('modal')
      @region.show(view)
      @region.$el.modal('show')
