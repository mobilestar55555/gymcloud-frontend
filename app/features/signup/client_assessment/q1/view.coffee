define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question1View extends QuestionBaseView

    template: template

    className: styles.question

    templateContext:
      s: styles

    behaviors:

      stickit:
        bindings:
          'input[name="gender"]': 'gender'

    _isValid: ->
      !!@model.get('gender')
