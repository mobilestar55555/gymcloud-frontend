define [
  './template'
], (
  template
) ->

  class StatsItemView extends Marionette.View

    template: template

    tagName: 'li'

    className: 'gc-folder row'

    behaviors:

      stickit:
        bindings: ->
          'a': 'title'
