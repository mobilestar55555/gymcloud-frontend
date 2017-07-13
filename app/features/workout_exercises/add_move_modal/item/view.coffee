define [
  './template'
  './styles'
], (
  template
  styles
) ->

  class AddMoveModalItem extends Marionette.View

    template: template

    className: "radio #{styles.folder_item}"
