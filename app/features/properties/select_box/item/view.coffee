define [
  './template'
], (
  template
) ->

  class PropertiesSelectBoxItemView extends Marionette.View

    template: template

    tagName: 'li'

    behaviors:
      stickit:
        bindings:
          'a':
            observe: ['name', 'global_property.unit']
            onGet: ([name, unit]) ->
              _.chain([name, unit]).compact().join(', ').value()

    triggers:
      'click a':
        event: 'selected'
        stopPropagation: false
