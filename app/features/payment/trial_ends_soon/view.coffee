define [
  './template'
], (
  template
) ->

  class TrialEndsSoonView extends Marionette.View

    template: template

    className: 'center-content-flex bg-white'

    behaviors:

      stickit:
        bindings:
          '.remains':
            observe: 'subscription_end_at'
            onGet: (date) ->
              days = moment(date).diff(moment(), 'days') or 0
              " #{days}"

    events:
      'click .close-block': 'destroy'
      'click [remind-tomorrow]': '_remindTomorrow'

    constructor: ->
      @model = App.request('current_user')
      super

    onAttach: ->
      remember_date = window.localStorage.subscription_remember_date
      mins = moment(remember_date).diff(moment(), 'minutes')
      mins > 0 and @destroy()

    _remindTomorrow: ->
      tomorow = moment().add(1, 'day').toString()
      window.localStorage.subscription_remember_date = tomorow
      @destroy()
