define [
  './template'
  './list/view'
], (
  template
  ListView
) ->

  class PersonalWorkoutExercisesLayoutView extends Marionette.View

    template: template

    className: 'gc-workouts-exercises-view'

    behaviors:

      stickit:
        model: ->
          @data
        bindings:
          '.blue-header':
            observe: 'blue_header'
            visible: true

      regioned:
        views: [
          region: 'workout_exercises_list'
          klass: ListView
        ]

    initialize: ->
      @data = new Backbone.Model(blue_header: !!@options.blue_header)