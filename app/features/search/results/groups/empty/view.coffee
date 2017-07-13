define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.View

    template: template

    templateContext: ->
      resources: @resources
      resource: _.singularize(@options.type)

    initialize: ->
      @resources = _.chain(@options.type).humanize().value().toLocaleLowerCase()
      @resources = 'results' if @options.type is 'all'
