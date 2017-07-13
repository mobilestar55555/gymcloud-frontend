define [
  './template'
  'features/payment/add_card/view'
  'features/payment/payment_methods/model'
], (
  template
  AddCardView
  CardModel
) ->

  class PaymentsInfoView extends Marionette.View

    template: template

    className: 'page-wrap payment-page'

    behaviors: ->

      regioned:
        views: [
            region: 'add_card'
            klass: AddCardView
            options: ->
              model: new CardModel
        ]

    onAttach: ->
      $('body').attr('class', 'auth')

    onDestroy: ->
      $('body').removeClass('auth')