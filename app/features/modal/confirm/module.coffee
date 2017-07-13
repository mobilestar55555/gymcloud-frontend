define [
  './view'
], (
  ModalConfirmView
) ->

  class Module

    constructor: (@app) ->
      @app.on 'start', =>
        @_initHandlers()

    _initHandlers: ->
      @app.reqres.setHandler('base:confirmationalModal', @_initModal)
      @app.reqres.setHandler('modal:confirm', @_initModal)
      @app.reqres.setHandler('modal:confirm:delete', @_initModalDelete)

    _initModal: (data) =>
      view = new ModalConfirmView data
      region = App.request('app:layouts:base').getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      @app.listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()

    _initModalDelete: (model, callback, options = {}) ->
      defer = new $.Deferred
      attrs = _.extend({}, {type: model.type, name: model.get('name')}, options)
      App.request 'modal:confirm',
        title: attrs.title || "Delete #{attrs.type}"
        content: attrs.content || "Are you sure you want to delete
          #{attrs.type} (#{attrs.name})?"
        confirmBtn: 'Delete'
        confirmCallBack: ->
          model.destroy(wait: true)
            .then ->
              App.request 'messenger:explain', 'item.deleted',
                type: attrs.type

            .then(defer.resolve)
            .fail(defer.reject)

      defer.promise()
