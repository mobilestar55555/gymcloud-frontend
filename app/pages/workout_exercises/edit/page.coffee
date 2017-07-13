define [
  'pages/exercise/page'
  'models/workout_exercise'
], (
  ExercisePage
  WorkoutExercise
) ->

  class WorkoutExercisePage extends ExercisePage

    initModel: ->
      new WorkoutExercise(id: @options.id)

    originalModel: ->
      user = App.request('current_user')
      user.workout_exercises?.get(@options.id)

    originalAttrsToListen: ->
      ['name', 'updated_at']
