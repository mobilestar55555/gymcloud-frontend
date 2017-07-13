define [
  '../question_base_view'
  './template'
  './styles'
  '../../pro_invite/model'
], (
  QuestionBaseView
  template
  styles
  ProRequestModel
) ->

  class Question9View extends QuestionBaseView

    next_view_key: 'auth/assessment_report'

    view_id: 9

    view_count: 9

    template: template

    className: styles.question

    templateContext:
      s: styles

    _isValid: ->
      true

    initialize: ->
      @model.save().then ->
        (new ProRequestModel).request()
