define [
  'features/program_weeks/list/view'
  'features/program_weeks/list/empty/view'
  'collections/program_workouts'
  'collections/program_weeks'
  './workouts/view'
  './template'
], (
  WeeksView
  WeekEmptyView
  ProgramWorkouts
  ProgramWeeks
  WorkoutListView
  template
) ->

  class OverviewView extends Marionette.View

    template: template

    regions:
      weeks: '.gc-program-weeks-list-region'
      workoutList: 'region[data-name="gc-program-workout-list"]'
      emptyState: 'region[data-name="gc-program-empty-state"]'

    ui:
      workoutList: 'region[data-name="gc-program-workout-list"]'
      weeks: '.gc-program-weeks-list-region'
      emptyState: 'region[data-name="gc-program-empty-state"]'

    initialize: ->
      @collection = @model.program_weeks

      @workoutsCollection = @model.program_workouts
      @views = @_prepareViews()

      @listenTo(@views.weeks, 'add:program_workout', @_addProgramWorkout)
      @listenTo @views.weeks,
        'add:program_workout:from_library',
        @_addProgramWorkoutFromLibrary
      @listenTo(@collection, 'update', @toggleEmptyState)
      @listenTo(@workoutsCollection, 'update', @toggleEmptyState)

    onAttach: ->
      for region, view of @views
        @showChildView(region, view)
      # emptyStateView = new WeekEmptyView()
      # @getRegion('emptyState').show emptyStateView
      @getUI('emptyState').addClass 'hidden'

      @toggleEmptyState()

    toggleEmptyState: ->
      if !@workoutsCollection.isEmpty() and @collection.isEmpty()
        @getUI('weeks').addClass 'hidden'
      else
        @getUI('weeks').removeClass 'hidden'

    _prepareViews: ->
      views = {}

      views.weeks = new WeeksView
        model: @model
        collection: @collection

      views.workoutList = new WorkoutListView
        program: @model
        collection: @workoutsCollection

      views

    _addProgramWorkout: ->
      @views.workoutList.addProgramWorkout()

    _addProgramWorkoutFromLibrary: (workoutId) ->
      @views.workoutList.addProgramWorkoutFromLibrary(workoutId)
