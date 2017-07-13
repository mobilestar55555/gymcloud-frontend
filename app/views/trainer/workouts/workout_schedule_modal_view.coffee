define [
  'templates/trainer/workouts/workout_schedule_modal'
], (
  template
) ->

  class WorkoutScheduleModal extends Marionette.View

    template: template

    ui:
      hasEndDate: '.gc-has-end-date'
      workoutEndDateWrapper: '.gc-workout-end-date-wrapper'

    behaviors:

      stickit:
        bindings:
          '.gc-workout-id': 'workoutId'
          '.gc-workout-repeat': 'repeat'
          '.gc-start-date': 'startDate'
          '.gc-end-date': 'endDate'

    events:
      'change @ui.hasEndDate': 'toggleEndDate'

    toggleEndDate: ->
      @getUI('workoutEndDateWrapper').toggleClass('hidden')
