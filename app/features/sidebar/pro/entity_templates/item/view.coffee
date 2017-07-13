define [
  './template'
], (
  template
)->
  class TemplateCollectionItemView extends Marionette.View

    template: template

    className: 'gc-sidebar-item'

    behaviors:

      stickit:
        bindings:
          '.gc-sidebar-folder-name': 'name'

    templateContext: ->
      type: @type
      isFolder: false

    initialize: (options)->
      @type = options.type
