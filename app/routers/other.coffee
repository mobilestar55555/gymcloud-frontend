define ->

  class Router extends Marionette.AppRouter

    appRoutes:

      '': 'root'

  class Controller extends Marionette.Controller

    root: ->
      Backbone.history.navigate '#welcome',
        trigger: true
        replace: true

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
