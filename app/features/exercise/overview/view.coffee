define [
  './template'
], (
  template
) ->

  class ExerciseOverviewView extends Marionette.View

    template: template

    className: 'gc-box-content gc-exercise-wrapper'

    behaviors:
      author_widget: true
      video_assigned:
        controls: false
      textarea_autosize: true
      stickit:
        bindings:
          '.gc-exercise-description': 'description'
