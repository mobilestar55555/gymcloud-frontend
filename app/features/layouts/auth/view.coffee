define [
  './template'
], (
  template
) ->

  class AuthLayoutView extends Marionette.View

    key: 'AuthLayoutView'

    template: template

    regions:
      content: 'region[data-name="content"]'

    templateContext:
      landingPath: (path) ->
        [
          document.location.origin.replace('app', 'www')
          path
        ].join('/')

    initialize: ->
      @_initHandlers()

    _initHandlers: ->
      App.reqres.setHandler('app:layouts:auth', => @)

    onAttach: ->
      App.vent.trigger('body:change-class', 'auth')
