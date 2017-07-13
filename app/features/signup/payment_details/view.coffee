define [
  'features/payment/info/view'
  './template'
  'features/payment/add_card/view'
  'features/payment/payment_methods/model'
  'features/payment/subscription/model'
  '../behavior'
], (
  PaymentsInfo
  template
  AddCardView
  CardModel
  SubscriptionModel
  AuthBodyClassBehavior
) ->

  class PaymentsDetails extends AddCardView

    template: template

    tagName: 'div'

    className: 'page-wrap payment-page'

    attributes: {}

    plans:
      'fitness_assessment':
        price: '59'
        name: 'Fitness Assessment'
      'custom_programming':
        price: '99'
        name: 'Custom Programming'
      'personal_coaching':
        price: '199'
        name: 'Personal Coaching'
      '1_on_1_live_virtual_coaching':
        price: '299'
        name: '1-on-1 Live Virtual Coaching'

    behaviors:

      navigate_back: true

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings: _.extend {}, AddCardView::behaviors.stickit.bindings,
          '.charge-recurrence':
            observe: 'id'
            onGet: ->
              return 'one time' if @options.planId is 'fitness_assessment'
              'monthly'
          '.coupon': 'coupon'
          '.bucks-count':
            observe: 'id'
            onGet: ->
              @plans[@options.planId].price
          '.plan-name':
            observe: 'id'
            onGet: ->
              @plans[@options.planId].name

    initialize: ->
      @model = new CardModel(name: App.request('current_user').get('name'))
      @listenTo(@, 'card:added', @_onCardAdded)

    _cardAdded: (ev) ->
      return @_onCardAdded() if !!@model.get('last4')
      super

    _onCardAdded: (_cardResponse) ->
      subscription = new SubscriptionModel _.compactObject
        plan_id: @options.planId
        coupon: @model.get('coupon')
      subscription
        .save()
        .then(_.bind(@_onSubscribe, @))

    _onSubscribe: ->
      path = ['auth', 'payment_success', @options.planId]
      App.vent.trigger('redirect:to', path)
