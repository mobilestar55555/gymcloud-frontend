define [
  './template'
], (
  template
) ->

  class ExercisePropertiesListItemReadableView extends Marionette.View

    template: template

    tagName: 'li'

    className: 'gc-property-item'

    behaviors:

      stickit:
        bindings:
          '.gc-property-value-name-label':
            observe: [
              'property_unit_name'
              'value_converted'
              'value2_converted'
            ]
            onGet: ([unit_name, value, value2]) ->
              propertyName = @model.personal_property.get('name')
              return propertyName unless value

              if unit_name == 'mmss'
                [mins, secs] = value
                periodType = propertyName.split(' ')[0]
                "#{periodType} - #{mins}MINS #{secs}S"
              else
                "#{_.compact([value, value2]).join(' - ')} #{unit_name}"
