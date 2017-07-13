define [
  'models/workout_exercise'
], (
  WorkoutExercise
) ->

  (user) ->

    @can 'view', WorkoutExercise, (model) ->
      true

    @can 'update', WorkoutExercise, (model) ->
      user.get('is_pro')
