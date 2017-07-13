define [
  './template'
], (
  template
)->
  class PersonalCollectionItemView extends Marionette.View

    template: template

    className: 'gc-sidebar-item'

    behaviors:

      stickit:
        bindings:
          '[data-bind="name"]': 'name'

    templateContext: ->
      type: @type

    initialize: (options)->
      @type = options.type
