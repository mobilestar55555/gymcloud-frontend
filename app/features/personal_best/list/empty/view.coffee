define [
  './template'
], (
  template
) ->

  class EmptyExerciseResults extends Marionette.View

    template: template

    className: 'no-exercise-results'

    behaviors: ->

      stickit:
        bindings:
          '.full-name':
            observe: 'name'
            onGet: (value) ->
              value or 'User'
