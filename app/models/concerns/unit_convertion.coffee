define [
  'mathjs'
], (
  mathjs
) ->

  round = (value, decimals) ->
    Number(Math.round(value + 'e' + decimals) + 'e-' + decimals) or null

  formatDuration = (secs) ->
    unit = mathjs.unit("#{secs} seconds")
    timeArray = unit.splitUnit(['mins', 'secs'])
    mins = timeArray[0].toNumber()
    secs = timeArray[1].toNumber()
    # "#{_.lpad(mins, 2, '0')}:#{_.lpad(secs, 2, '0')}"
    [mins, secs]

  convertDuration = (duration) ->
    timeArray = duration.split(':')
    timeArray[1] * 1 + timeArray[0] * 60

  get: (name, attrs) ->
    if attrs[name] and @get('property_unit_name') is 'mmss'
      return formatDuration(attrs[name])

    if !attrs[name] or
      _.include([0, 1], @personal_property.property_units.length) or
      !@get('property_unit_id')
        return round(attrs[name], 0)

    saveUnit = @personal_property.get('save_unit').short_name
    unit = mathjs.unit("#{attrs[name]} #{saveUnit}")
    value = unit.toNumber(@get('property_unit_name'))
    round(value, 0)

  set: (name, value, attrs) ->
    if value and @get('property_unit_name') is 'mmss'
      return attrs[name] = convertDuration(value)

    if !value or
      _.include([0, 1], @personal_property.property_units.length) or
      !@get('property_unit_id')

        return attrs[name] = round(value, 5)

    saveUnit = @personal_property.get('save_unit').short_name
    unit = mathjs.unit("#{value} #{@get('property_unit_name')}")
    newValue = unit.toNumber(saveUnit)
    attrs[name] = round(newValue, 5)
