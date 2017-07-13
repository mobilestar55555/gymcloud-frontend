define [
  './template'
], (
  template
) ->

  class ExercisePropertiesItemView extends Marionette.View

    className: 'property-item'

    template: template

    behaviors:

      stickit:
        bindings:
          'span':
            observe: ['value_converted', 'property_unit_name']
            onGet: (values) -> values.join(' ')
