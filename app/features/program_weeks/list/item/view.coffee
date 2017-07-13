define [
  './template'
  'features/program_workouts/list/view'
], (
  template
  ProgramWorkoutsListView
) ->

  class ProgramWeeksListItemView extends Marionette.View

    template: template

    className: 'gc-program-week-item'

    behaviors:

      stickit:
        bindings:
          '[data-bind="name"]':
            observe: 'name'
            events: ['blur']
          '.workouts-count':
            observe: 'workouts_count'
            onGet: (value) ->
              "(#{value})"

      regioned:
        views: [
            region: 'week_workouts'
            klass: ProgramWorkoutsListView
            options: ->
              weekId: @model.get('id')
              hasEmptyView: true
              model: @program
              collection: @workouts
        ]

    ui:
      removeWeek: '.gc-remove-program-week'

    events:
      'click @ui.removeWeek': 'removeModel'
      'click .expand, .compress': '_toggleWeek'
      'keydown [data-bind="name"]': '_preventEnter'
      'click a[data-action="duplicate"]': '_duplicateWeek'

    initialize: ->
      @program = @model.collection.program
      @workouts = new Backbone.VirtualCollection @program.workouts,
        filter: (model) => model.get('week_id') == @model.get('id')
        comparator: 'position'
      @workouts.week_id = @model.get('id')
      @listenTo(@workouts, 'add remove reset', @_countWorkouts)
      @listenTo(@model, 'change:name', -> @model.save())
      @_countWorkouts()

    _countWorkouts: ->
      @model.set(workouts_count: @workouts.length)

    removeModel: ->
      App.request('modal:confirm:delete', @model)

    _toggleWeek: ->
      @$el.toggleClass('folded')

    _preventEnter: (ev) ->
      if ev.which in [13, 27]
        ev.preventDefault()
        $(ev.currentTarget).blur()
        window.getSelection().removeAllRanges()

    _duplicateWeek: ->
      @model.duplicate().then (newProgramWeek) =>
        @model.collection.add(newProgramWeek)
        @workouts.each (workout) =>
          workout.duplicate().then (newProgramWorkout) =>
            newProgramWorkout.save('week_id': newProgramWeek.get('id'))
            @program.workouts.add(newProgramWorkout)
