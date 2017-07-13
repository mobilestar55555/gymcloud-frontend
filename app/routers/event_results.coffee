define [
  'pages/workout_enter_result/page'
  'pages/event_results/page'
], (
  WorkoutEnterResultPage
  EventResultsPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'events/:event_id/results(/:comments)': 'results'
      'workout_enter_result(/)': 'root'

  class Controller extends Marionette.Controller

    root: ->
      new WorkoutEnterResultPage

    results: (eventId, comments) ->
      new EventResultsPage(
        id: eventId
        state: 'root'
        comments: !!comments
      )

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
