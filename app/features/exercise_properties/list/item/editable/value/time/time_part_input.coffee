define [
  './styles'
], (
  styles
) ->

  class TimePartInputView extends Marionette.View

    template: _.noop

    tagName: 'input'

    className: styles.time_part

    attributes:
      type: 'number'
      min: 0
      max: 60

    behaviors:
      stickit:
        bindings:
          ':el': 'value'

    events:
      'keypress': '_typeAllowedChars'
      'paste': '_handlePaste'

    initialize: ->
      @el.placeholder = @options.placeholder

    _handlePaste: (ev) ->
      ev.preventDefault()
      data = ev.clipboardData ||
        ev.originalEvent.clipboardData ||
        window.clipboardData
      value = data.getData('text').replace(/[^\d]/ig, '')
      @model.set(value: _.truncate(value, 2))
      false

    _typeAllowedChars: (ev) ->
      key = ev.keyCode || ev.which
      char = String.fromCharCode(key)
      currentValue = $(ev.currentTarget).val()

      if currentValue.length >= 2
        return false
      else if not char.match(/[\d]/i)
        return false
      ev
