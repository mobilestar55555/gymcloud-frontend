define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question3View extends QuestionBaseView

    next_view_key: '4'

    view_id: 3

    template: template

    className: styles.question

    templateContext:
      s: styles

    behaviors:

      stickit:
        bindings:
          'textarea': 'reason'

    _isValid: ->
      reason = @model.get('reason') or ''
      reason.length >= 6
