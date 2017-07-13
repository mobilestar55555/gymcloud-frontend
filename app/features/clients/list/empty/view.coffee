define [
  './template'
  './styles'
], (
  template
  styles
) ->
  class EmptyView extends Marionette.View

    className: styles.list_empty

    tagName: 'li'

    template: template

    templateContext: ->
      clientType: _.singularize(@options.clientType)
      s: styles
