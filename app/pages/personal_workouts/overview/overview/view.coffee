define [
  './template'
  'features/personal_workout_exercises/view'
  'features/video/program_video/view'
], (
  template
  WorkoutExercisesView
  ProgramVideoView
) ->

  class PersonalWorkoutOverviewView extends Marionette.View

    template: template

    className: 'gc-box-content'

    behaviors:
      regioned:
        views: [
            region: 'workout_exercises'
            klass: WorkoutExercisesView
            options: ->
              model: @model
              collection: @model.exercises
          ,
            region: 'program_video'
            klass: ProgramVideoView
            options: ->
              model: @model
              readonly: true
        ]

      stickit:
        bindings:
          '.note':
            observe: 'note'
            visible: true
            updateView: true
