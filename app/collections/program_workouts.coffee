define [
  'models/program_workout'
], (
  ProgramWorkout
) ->

  class ProgramWorkouts extends Backbone.Collection

    type: 'ProgramWorkouts'

    model: ProgramWorkout

    url: ->
      root = _.chain(@program.type).underscore().pluralize().value()
      "/#{root}/#{@program.id}/program_workouts?#{$.param(nested: false)}"

    comparator: ['position', 'id']
