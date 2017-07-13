define [
  'pages/clients/list/page'
], (
  ClientsListPage
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'clients/:state': 'list'

  class Controller extends Marionette.Controller

    list: (state) ->
      new ClientsListPage
        state: state

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
