define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question8View extends QuestionBaseView

    next_view_key: '9'

    view_id: 8

    view_count: 9

    template: template

    className: styles.question

    templateContext:
      s: styles

    behaviors:

      stickit:
        bindings:
          'textarea': 'impact'

    _isValid: ->
      !!@model.get('impact')
