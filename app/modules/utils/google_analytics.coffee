define [
  'config'
], (
  config
) ->

  class GoogleAnalyticsModule

    account: config.vendor.google_analytics?.account

    constructor: (@app) ->
      @app.on('start', @_init)

    _init: ->
      @_initTag window, document, 'script', \
        '//www.google-analytics.com/analytics.js', 'ga'
      ga('create', @account, 'auto')
      ga('set', 'transport', 'beacon')
      @_bindToRouter()

    _initTag: (i, s, o, g, r, a, m) ->
      i['GoogleAnalyticsObject'] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push arguments
        return

      i[r].l = 1 * new Date
      a = s.createElement(o)
      m = s.getElementsByTagName(o)[0]
      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
      return

    _triggerPageView: ->
      ga('send', 'pageview')

    _bindToRouter: ->
      Backbone.history.on 'all', (route, router) =>
        @_triggerPageView()
