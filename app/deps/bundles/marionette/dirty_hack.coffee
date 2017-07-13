define ->

  (oMarionette) ->

    class DirtyHackView extends oMarionette.View

      initialize: ->
        super
        @render()

      template: ->
        '<div/>'

      ui:
        first: 'div:first'

      _bindUIElements: ->
        result = super
        first = @getUI('first')
        $.extend(first.constructor.fn.constructor::, $.fn.constructor::)
        result

    new DirtyHackView
