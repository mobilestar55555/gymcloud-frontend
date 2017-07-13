define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.View

    tagName: 'table'

    template: template
