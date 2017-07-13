define [
  './template'
], (
  template
) ->
  class EmptyView extends Marionette.View

    className: 'gc-properties-list-empty'

    template: template
