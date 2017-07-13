define [
  './template'
], (
  template
) ->

  class EntityEmptyView extends Marionette.View

    template: template

    className: 'gc-global-list-splash'

    templateContext: ->
      singularName: @singularName

    initialize: (options) ->
      @singularName = _.chain(options.type).humanize().singularize().value()