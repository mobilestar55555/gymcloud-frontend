define [
  'pages/personal_workouts/list/page'
], (
  BasePage
) ->

  class Page extends BasePage

    initCollection: ->
      App.request('current_user').personal_warmups
