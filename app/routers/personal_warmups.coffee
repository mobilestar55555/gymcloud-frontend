define [
  'pages/personal_workouts/overview/page'
  'pages/personal_workouts/edit/page'
  'pages/personal_warmups/list/page'
], (
  PersonalWarmupsOverviewPage
  PersonalWarmupsEditPage
  PersonalWarmupsListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'personal_warmups/:id': 'overview'
      'personal_warmups/:id/edit': 'edit'
      'personal_warmups(/)': 'list'

  class Controller extends Marionette.Controller

    overview: (id, state) ->
      new PersonalWarmupsOverviewPage
        id: id
        state: 'overview'
    edit: (id, state) ->
      new PersonalWarmupsEditPage
        id: id
        state: 'edit'
    list: (id, state) ->
      new PersonalWarmupsListPage
        state: 'list'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
