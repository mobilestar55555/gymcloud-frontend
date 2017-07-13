define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question2View extends QuestionBaseView

    next_view_key: '3'

    view_id: 2

    template: template

    className: styles.question

    templateContext:
      s: styles

    behaviors:
      date_input_picker: [
          selector: 'input[name="birthday"]'
          defaultDate: moment().subtract(18, 'years').toDate()
          minDate: moment().subtract(120, 'years').toDate()
          maxDate: moment().toDate()
      ]

      stickit:
        bindings:
          'input[name="birthday"]':
            observe: 'birthday'
            getVal: ($el) ->
              $el[0].picker?.getMoment().format('YYYY-MM-DD')
          'input[name="weight"]':
            observe: 'weight'
            events: ['change', 'cut', 'paste', 'blur']
          'input[name="height_feet"]':
            observe: 'height_feet'
            events: ['change', 'cut', 'paste', 'blur']
          'input[name="height_inches"]':
            observe: 'height_inches'
            events: ['change', 'cut', 'paste', 'blur']

    events:
      'input input[name="height_feet"]': '_onFeetInput'

    initialize: ->
      @listenTo(@model, 'change:height', @_onHeightChange)
      @listenTo(@model, 'change:weight', @_onWeightChange)

    _isValid: ->
      _.all(['birthday', 'weight', 'height'], (name) => !!@model.get(name))

    _onFeetInput: (ev) ->
      input = ev.currentTarget
      input.value = 7 if input.value > 7
      input.value = 0 if input.value < 0

    _onHeightChange: ->
      value = @model.get('height')
      @model.set(height: 95) if value > 95 # 7ft*12 + 11in
      @model.set(height: 0) if value < 0

    _onWeightChange: ->
      value = parseInt(@model.get('weight'))
      @model.set(weight: 999) if value > 999
      @model.set(weight: 100) if value < 100
