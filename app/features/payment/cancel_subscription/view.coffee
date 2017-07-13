define [
  './template'
  'features/payment/subscription/model'
], (
  template
  Subscription
) ->

  class CancelSubscriptionModalView extends Marionette.View

    template: template

    events:
      'click button.btn-danger': '_cancelSubscription'

    initialize: ->
      @model = new Subscription
      @model.fetch()
      @model.url = Backbone.Model.prototype.url

    _cancelSubscription: ->
      isConfirmed = confirm('Are you sure?')
      return unless isConfirmed
      @model.destroy()
