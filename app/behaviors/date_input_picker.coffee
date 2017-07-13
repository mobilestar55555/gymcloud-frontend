define [
  'pikaday'
  'pikaday/css/pikaday'
], (
  Pikaday
  pikadayStyles
) ->

  class DateInputPickerBehavior extends Marionette.Behavior

    key: 'date_input_picker'

    onAttach: ->
      @_pickers = []
      @options ||= []

      _.each @options, (item) =>
        options = @_getPickerOptions(item)
        picker = new Pikaday(options)
        picker.field = options.field
        options.field.picker = picker
        @_pickers.push(picker)

    onDestroy: ->
      _.each @_pickers, (picker) ->
        delete picker.field.picker
        delete picker.field
        picker.destroy()

    _getPickerOptions: (options = {}) ->
      el = @view.$el.find(options.selector)[0]

      defaultOptions =
        field: el
        format: 'MM/DD/YYYY'
        yearRange: 100
        firstDay: 0
        container: el.parentElement

      _.extend({}, defaultOptions, options)
