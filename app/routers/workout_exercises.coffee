define [
  'pages/workout_exercises/list/page'
  'pages/workout_exercises/edit/page'
], (
  WorkoutExercisesListPage
  WorkoutExercisePage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'workout_exercises(/)': 'list'
      'workout_exercises/:id': 'root'
      'workout_exercises/:id/:state': 'single'

  class Controller extends Marionette.Controller

    list: ->
      new WorkoutExercisesListPage
        state: 'list'

    root: (id) ->
      path = ['workout_exercises', id, 'overview']
      App.vent.trigger('redirect:to', path, trigger:true, replace: true)

    single: (id, state) ->
      new WorkoutExercisePage
        id: id
        state: state

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
