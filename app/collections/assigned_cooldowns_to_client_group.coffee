define [
  './assigned_workout_templates_to_client_group'
], (
  AssignedWorkoutTemplates
) ->

  class AssignedCooldownsToClientGroup extends AssignedWorkoutTemplates

    url: ->
      "#{@clientGroup.url()}/assignments/cooldowns"
