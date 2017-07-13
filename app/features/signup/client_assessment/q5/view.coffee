define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question5View extends QuestionBaseView

    view_id: 5

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
          'input[type="text"]': 'improve'
          'input[type="radio"]': 'improve_option'
          '.other':
            observe: 'improve'
            updateModel: false
            afterUpdate: ($el) -> $el.trigger('change')
            attributes: [
                name: 'checked'
                observe: 'improve'
                onGet: (value) -> !!value
            ]

    events:
      'change input[type="radio"]': '_onRadioClicked'

    questionNumber: 5

    titleText: 'Select your primary Fitness Goal'

    improveOptions: [
        id: 1
        text: 'Improve My Health and Well-Being'
      ,
        id: 2
        text: 'Improve My Physical Appearance'
      ,
        id: 3
        text: 'Improve my Performance'
      ,
        id: 4
        text: false
    ]

    initialize: ->
      @listenTo @model, 'change:improve_option', ->
        option = @model.get('improve_option')
        count = {'1': 8, '2': 8, '3': 9, '4': 7}[option] || 8
        @trigger('change:progress', view_count: count)

    _isValid: ->
      option = @model.get('improve_option')
      (option in ['1', '2', '3']) or
        (option is '4' and !!@model.get('improve'))

    _onRadioClicked: (ev) ->
      @$el.find(".#{styles.checked}").removeClass(styles.checked)
      el = ev.currentTarget
      $el = $(el)
      @model.set(improve: undefined) if $el.val() isnt '4'
      method = if el.checked then 'addClass' else 'removeClass'
      label = $el.parent()
      label[method](styles.checked)

    getNextViewKey: ->
      key = @model.get('improve_option')
      return '8' if key is '4'
      "6_#{key}"
