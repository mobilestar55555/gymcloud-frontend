define [
  './template'
  'config'
], (
  template
  config
) ->

  class AddCardView extends Marionette.View

    template: template

    tagName: 'form'

    className: 'payment-info'

    attributes:
      role: 'form'

    templateContext: ->
      year = (new Date).getFullYear()
      year = 2017 if year < 2017

      yearFrom: year
      yearTo: year + 15

    behaviors:

      stickit:
        bindings:
          '.full-name': 'name'
          '.number': 'number'
          '.exp_month': 'exp_month'
          '.exp_year': 'exp_year'
          '.cvc': 'cvc'
          '.payment-notice a':
            attributes: [
                name: 'href',
                observe: 'id',
                onGet: -> "#{config.langing.url}/client#pricing"
            ]

    events:
      'click button[type="submit"]': '_cardAdded'

    constructor: ->
      @_initStripe()
      super

    initialize: ->
      @listenTo @, 'card:added', ->
        @model.clear()

    _initStripe: ->
      return if window.Stripe
      $.ajax
        url: 'https://js.stripe.com/v2/'
        dataType: 'script'
        async: true
        beforeSend: -> # don't add our domain to url
        success: ->
          key = config.vendor.stripe.publishable_key
          window.Stripe.setPublishableKey(key)

    _cardAdded: (ev) ->
      ev.preventDefault()
      attributes = @model.pick(_.keys(@model.defaults))
      callback = _.bind(@_stripeResponseHandler, @)
      window.Stripe.card.createToken(attributes, callback)

    _stripeResponseHandler: (status, response) ->
      return @_showError(response.error.message) if response.error

      attrs = _.extend(@model.toJSON(), response.card, id: response.id)
      @model.patch(attrs)
        .then (cardResponse) =>
          @trigger('card:added', cardResponse)
        .fail (error) =>
          @_showError(error.responseJSON.error)

    _showError: (message) ->
      App.request('messenger:show', type: 'error', message: message)
