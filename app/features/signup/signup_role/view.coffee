define [
  './styles'
  './template'
  '../behavior'
], (
  styles
  template
  AuthBodyClassBehavior
) ->

  class SignUpRoleView extends Marionette.View

    template: template

    className: styles.select_form

    templateContext:
      s: styles

    behaviors:

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    events:
      'submit form': '_onTypeSelected'

    _onTypeSelected: ->
      isPro = !!@$el.find('input[type="radio"]:checked').val()
      path = "signup?is_pro=#{isPro}"
      App.vent.trigger('redirect:to', path, replace: false)
