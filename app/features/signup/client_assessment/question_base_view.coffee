define ->

  class QuestionBaseView extends Marionette.View

    view_id: 1

    view_count: 9

    next_view_key: '2'

    onAttach: ->
      @notify(view_id: @view_id, view_count: @view_count, is_valid: @_isValid())
      @listenTo(@model, 'change', -> @notify(is_valid: @_isValid()))

    getNextViewKey: ->
      @next_view_key

    _isValid: ->
      throw Error('unimplemented')

    notify: (attrs) ->
      @trigger('change:progress', attrs)
