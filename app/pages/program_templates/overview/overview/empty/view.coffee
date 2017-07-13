define [
  './template'
  'features/program_action_panel/editable/view'
  'features/quick_add/view'
], (
  template
  EditableProgramActionPanel
  QuickAddView
) ->

  class EmptyProgramView extends EditableProgramActionPanel

    className: 'gc-program-empty-placeholder text-center'

    template: template

    behaviors:
      stickit:
        model: -> @data
        bindings:
          ':el':
            observe: 'is_visible'
            visible: true
          '.buttons':
            observe: 'state'
            visible: (value) ->
              value isnt 'autocomplete'
          'region[data-name="quick_add"]':
            observe: 'state'
            visible: (value) ->
              value is 'autocomplete'

      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: ->
              collection: App.request('current_user').workout_templates
              typeToAdd: 'Workout'
              newButtonName: 'Add New'
        ]

    initialize: ->
      super
      @listenTo(@model.weeks, 'add remove reset', @_setCount)
      @listenTo(@data, 'change:workoutsCount', @_setCount)

    _setCount: ->
      count = @model.weeks.length + @data.get('workoutsCount')
      @data.set(is_visible: !count)
