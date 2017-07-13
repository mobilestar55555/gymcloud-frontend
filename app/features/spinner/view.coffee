define [
  './template'
  './styles'
], (
  template
  styles
) ->

  class SpinnerView extends Marionette.View

    template: template

    templateContext:
      s: styles

    className: styles.gc_spinner

    ui:
      clock: ".#{styles.gc_busy_indicator_clock}"
      pointer: ".#{styles.pointer}"
      message: ".#{styles.message}"

    onAttach: ->
      @listenTo(@, 'start', @_start)
      @listenTo(@, 'stop', @_stop)
      @

    _start: =>
      @_messageTimeoutId = _.chain(@_showMessage)
        .bind(@)
        .delay(2000)
        .value()
      @_show()
      @_activate()

    _stop: =>
      clearTimeout(@_messageTimeoutId)
      @_hideMessage()
      @_deactivate(@_hide)

    _show: ->
      @getUI('clock').stop()
      @$el.show()

    _hide: ->
      @getUI('clock').stop()
      @$el.fadeOut('fast')

    _activate: ->
      @getUI('pointer').stop()
        .fadeIn('fast')

    _deactivate: (cb) ->
      @getUI('pointer').stop()
        .fadeOut 'fast', =>
          cb.apply(@)

    _showMessage: ->
      @getUI('message').stop()
        .fadeIn('fast')

    _hideMessage: (cb) ->
      @getUI('message').stop()
        .fadeOut('fast')
