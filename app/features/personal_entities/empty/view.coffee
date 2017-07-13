define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.View

    template: template

    className: 'gc-client-assignments-empty'

    templateContext: =>
      name: @options.name
