define ->

  class DefaultPropertyView extends Marionette.View

    template: _.noop

    tagName: 'span'

    className: 'gc-property-value'

    attributes:
      contenteditable: true

    behaviors:
      stickit:
        bindings:
          ':el':
            observe: ['value_converted', 'value2_converted']
            onGet: ([value, value2]) ->
              _.chain([value, value2]).compact().join('-').value()
            onSet: (input) ->
              input.split(/\-+/)
            events: ['blur', 'change']

    events:
      'keypress': '_handleKeyPress'
      'paste': '_handlePaste'

    initialize: ->
      @listenTo(@, 'select_value', @_selectValue)

    _selectValue: ->
      @$el.focus()
      setTimeout =>
        @$el.selectText()
      , 100

    _handlePaste: (ev) ->
      ev.preventDefault()
      data = ev.clipboardData ||
        ev.originalEvent.clipboardData ||
        window.clipboardData
      [value, value2] = data
        .getData('text')
        .replace(/[^\d\-]/ig, '')
        .split(/\s*\-\s*/)
      @model.set
        value: value
        value2: value2
      false

    _handleKeyPress: (ev) ->
      @_saveOnEnter(ev) or @_typeAllowedChars(ev)

    _saveOnEnter: (ev) ->
      return true unless ev.which is 13
      ev.preventDefault()
      ev.currentTarget.blur()
      setTimeout((=> @trigger('save_property')), 200)
      window.getSelection().removeAllRanges()
      false

    _typeAllowedChars: (ev) ->
      key = ev.keyCode || ev.which
      char = String.fromCharCode(key)
      currentValue = $(ev.currentTarget).text()

      if key in [8..46]
        return true
      else if not @_inputValuesLengthIsValid(currentValue)
        return false
      else if char.match(/[\-\:]/) and not currentValue.match(/[\d]+/)
        return false
      else if char.match(/[\-\:]/) and currentValue.match(/[\-]+/)
        return false
      if not char.match(/[\d\-\:]/i)
        return false

    _inputValuesLengthIsValid: (text) ->
      _.all text.split(/\s*\-\s*/), (value) ->
        value.length <= 4
