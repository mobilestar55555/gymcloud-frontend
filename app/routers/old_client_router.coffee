define [
  'views/client/clientpage-calendar-day-view'
  'views/client/clientpage-calendar-week-view'
  'views/client/clientpage-calendar-month-view'
], (
  CalendarDayView
  CalendarWeekView
  CalendarMonthView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'calendar(/)': 'clientPageCalendarDay'
      'calendar/day/:day(/)': 'clientPageCalendarDay'
      'calendar/week/:week(/)': 'clientPageCalendarWeek'
      'calendar/month/:month(/)': 'clientPageCalendarMonth'
      'calendar/:date': 'notImplementedYet'

  class Controller extends Marionette.Controller

    clientPageCalendarDay: (id) =>
      view = new CalendarDayView()
      @_showView(view)

    clientPageCalendarWeek: (id) =>
      view = new CalendarWeekView()
      @_showView(view)

    clientPageCalendarMonth: (id) =>
      view = new CalendarMonthView()
      @_showView(view)

    notImplementedYet: (_date) ->
      App.request('messenger:explain', 'error.mobile_only')
      App.vent.trigger('redirect:to', ['welcome'])

    _showView: (view) ->
      mainView = App.request('app:layouts:main')
      mainView.getRegion('content').show(view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
