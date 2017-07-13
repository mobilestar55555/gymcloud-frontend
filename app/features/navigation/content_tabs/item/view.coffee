define [
  './template'
], (
  template
)->

  class View extends Marionette.View

    template: template

    tagName: 'li'

    behaviors:

      stickit:
        bindings:
          ':el':
            attributes: [
              name: 'class'
              observe: 'active'
              onGet: (value) ->
                value && 'active' || ''
            ]
            classes:
              hidden: 'hidden'

          '[data-bind="title"]': 'title'

    triggers:
      'click': 'switch'

    initialize: ->
      @model.get('enabled')(@model)
