define ->

  class ProgramWeek extends Backbone.Model

    type: 'ProgramWeek'

    urlRoot: '/program_weeks/'

    defaults:
      name: undefined
      program_id: undefined
      position: undefined

    setPosition: (pos) ->
      @save({
        position: pos
        name: "Week #{pos}"
      }, wait: true)

    duplicate: ->
      newProgramWorkout = new ProgramWeek
        program_id: @get('program_id')
        program_type: @get('program_type')
        position: @collection?.length + 1
        name: 'Week'
        workouts_count: @get('workouts_count')

      newProgramWorkout.save({}, wait: true).then ->
        newProgramWorkout
