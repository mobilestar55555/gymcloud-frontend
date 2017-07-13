define [
  './template'
], (
  template
) ->

  class UserAuthenticationView extends Marionette.View

    template: template

    className: 'authentication'

    ui:
      removeAuth: '.glyphicon-remove'

    events:
      'click @ui.removeAuth': '_removeAuth'

    _removeAuth: ->
      @model.destroy()

