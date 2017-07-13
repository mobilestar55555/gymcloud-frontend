define [
  './default'
  './time/view'
], (
  Default
  Time
) ->

  class PropertyValueView

    @viewClass = (unit) ->
      {
        mmss: Time
      }[unit] || Default

    constructor: (options = {}) ->
      unit = options.model?.get('property_unit_name')
      Klass = @constructor.viewClass(unit)
      return new Klass(arguments...)
