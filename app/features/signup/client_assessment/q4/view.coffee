define [
  '../question_base_view'
  './template'
  './styles'
], (
  QuestionBaseView
  template
  styles
) ->

  class Question4View extends QuestionBaseView

    next_view_key: '5'

    view_id: 4

    template: template

    className: styles.question

    templateContext: ->
      s: styles
      equipment: @equipment

    behaviors:

      stickit:
        bindings:
          'input[type="checkbox"]': 'equipment'
          'input[type="text"]': 'other_equipment'
          '.other':
            observe: 'other_equipment'
            onGet: (v) -> v
            afterUpdate: ($el) -> $el.trigger('change')
            attributes: [
                name: 'checked'
                observe: 'other_equipment'
                onGet: (value) -> !!value
              ,
                name: 'value'
                observe: 'other_equipment'
            ]

    events:
      'change input[type="checkbox"]': '_onCheckboxChanged'

    equipment: [
      'Barbells'
      'Dumbbells'
      'Cable Machines'
      'Kettlebells'
      'Medicine Balls'
      'Resistance Bands'
      'Cardio Equipment'
      'Suspension Trainer'
    ]

    _isValid: ->
      @model.get('equipment').length > 0

    _onCheckboxChanged: (ev) ->
      el = ev.currentTarget
      $el = $(el)
      method = if el.checked then 'addClass' else 'removeClass'
      label = $el.parent()
      label[method](styles.checked)
