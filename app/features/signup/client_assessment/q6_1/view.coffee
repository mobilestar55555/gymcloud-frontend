define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question6View extends QuestionBaseView

    next_view_key: '8'

    view_id: 6

    template: template

    className: styles.question

    templateContext: ->
      s: styles
      question: @questionNumber
      title: @titleText
      improveOptions: @improveOptions

    behaviors:

      stickit:
        bindings:
          'input[type="radio"]': 'improve'
          'input[type="text"]': 'other_improve'
          '.other':
            observe: 'other_improve'
            onGet: (v) -> v
            afterUpdate: ($el) -> $el.trigger('change')
            attributes: [
                name: 'checked'
                observe: 'other_improve'
                onGet: (value) -> !!value
              ,
                name: 'value'
                observe: 'other_improve'
            ]

    events:
      'change input[type="radio"]': '_onRadioClicked'

    questionNumber: 6

    titleText: 'Choose the aspect of "Improved Health and Well-Being" that is
                most important to you.'

    improveOptions: [
        text: 'I want to feel better about myself'
      ,
        text: 'I want to decrease my risk of disease'
      ,
        text: 'I want to combat a pre-existing condition'
      ,
        text: '' # Other please explain
    ]

    _isValid: ->
      !!@model.get('improve')

    _onRadioClicked: (ev) ->
      @$el.find(".#{styles.checked}").removeClass(styles.checked)
      el = ev.currentTarget
      $el = $(el)
      method = if el.checked then 'addClass' else 'removeClass'
      label = $el.parent()
      label[method](styles.checked)
