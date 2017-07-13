define [
  './template'
], (
  template
) ->
  class FolderItemView extends Marionette.View

    template: template

    triggers:
      'click .gc-add-modal-folder a': 'folder:clicked'

    templateContext: ->
      type: @options.type
      isFolder: !!@model.items