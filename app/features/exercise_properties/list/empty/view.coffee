define [
  './template'
], (
  template
) ->

  class ExercisePropertiesEmptyView extends Marionette.View

    template: template

    tagName: 'li'

    className: 'gc-property-item empty'
