define [
  './styles'
  './template'
  '../behavior'
], (
  styles
  template
  AuthBodyClassBehavior
) ->

  class PaymentSuccessView extends Marionette.View

    tagName: 'header'

    className: "gc-header-standard gc-header-login #{styles.payment_success}"

    template: template

    templateContext:
      s: styles

    behaviors:
      navigate_back: true
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    events:
      "click .#{styles.next}": '_onNext'

    _onNext: ->
      path = ['auth', 'client_assessment']
      App.vent.trigger('redirect:to', path, replace: false)
