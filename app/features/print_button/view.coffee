define [
  './template'
], (
  template
) ->

  class View extends Marionette.View

    template: template

    tagName: 'button'

    className: 'btn'

    events:
      'click': '_print'

    _print: ->
      window.print()
