define [
  './template'
], (
  template
) ->

  class TrialEndedView extends Marionette.View

    template: template

    className: 'page-wrap payment-page'

    onAttach: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')
