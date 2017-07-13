define [
  './time_part_input'
  './semicolon'
  './styles'
], (
  TimePartInputView
  SemicolonView
  styles
) ->

  class TimeInputCollectionView extends Marionette.CollectionView

    className: styles.time_input

    childView: (model) ->
      return SemicolonView if _.isString(model.get('value'))
      TimePartInputView

    childViewOptions: (_model, index) ->
      placeholder: {0: 'M', 2: 'S'}[index]

    initialize: ->
      @listenTo(@collection, 'change:value', @_onChangeTimePart)

    _onChangeTimePart: (model, _value, _options) ->
      mins = parseInt((@collection.first().get('value') or 0), 10)
      secs = parseInt((@collection.last().get('value') or 0), 10)
      value = if mins is 0 and secs is 0 then null else "#{mins}:#{secs}"
      @trigger('change:value', value)
