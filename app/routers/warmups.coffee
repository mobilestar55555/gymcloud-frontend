define [
  'pages/workout_templates/overview/page'
], (
  WorkoutTemplateOverviewPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'warmups': 'toFolder'
      'warmups/:id': 'root'
      'warmups/:id/:state': 'overview'

  class Controller extends Marionette.Controller

    toFolder: ->
      user = App.request('current_user')
      id = user.getRootFolderFor('Warmup Templates').get('id')
      path = ['warmups_folder', id]
      App.vent.trigger('redirect:to', path)

    root: (id) ->
      path = ['warmups', id, 'overview']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new WorkoutTemplateOverviewPage
        id: id
        state: state

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
