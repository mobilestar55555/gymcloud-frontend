define [
  './assigned_workout_templates_to_client_group'
], (
  AssignedWorkoutTemplates
) ->

  class AssignedWarmupsToClientGroup extends AssignedWorkoutTemplates

    url: ->
      "#{@clientGroup.url()}/assignments/warmups"
