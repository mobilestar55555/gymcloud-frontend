define [
  'features/exercise_properties/list_readable/item/view'
  './template'
], (
  ReadableItemView
  template
) ->

  class ExercisePropertiesListItemReadableView extends ReadableItemView

    template: template

    ui: ->
      removePropertyButton: '.gc-remove'
      toggleEditMode: '.gc-toggle-edit-mode'

    triggers:
      'click @ui.toggleEditMode': 'switchTo:editable'

    events: ->
      'click @ui.removePropertyButton': 'removeProperty'

    removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @model.destroy(wait: true)
