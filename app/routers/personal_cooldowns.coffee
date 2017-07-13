define [
  'pages/personal_workouts/overview/page'
  'pages/personal_workouts/edit/page'
  'pages/personal_cooldowns/list/page'
], (
  OverviewPage
  EditPage
  ListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_cooldowns/:id': 'overview'
      'personal_cooldowns/:id/edit': 'edit'
      'personal_cooldowns(/)': 'list'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new OverviewPage
        id: id
        state: 'overview'
    edit: (id, state) ->
      new EditPage
        id: id
        state: 'edit'
    list: (id, state) ->
      new ListPage
        state: 'list'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
