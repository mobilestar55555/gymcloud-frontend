define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.View

    tagName: 'tr'

    className: 'empty'

    template: template
