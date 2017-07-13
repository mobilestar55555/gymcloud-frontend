define [
  './styles'
  './template'
  './model'
  '../behavior'
], (
  styles
  template
  ConfirmationModel
  AuthBodyClassBehavior
) ->

  class ConfirmAccountView extends Marionette.View

    tagName: 'header'

    className: "gc-header-standard gc-header-login #{styles.confirm_account}"

    template: template

    templateContext:
      s: styles

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings:
          'input': 'email'

    events:
      'submit form': '_resendInstructions'
      'click .btn': '_resendInstructions'

    initialize: ->
      @model = new ConfirmationModel
        email: App.request('current_user').get('email')

    _resendInstructions: ->
      @model.save()
        .then ->
          App.request('messenger:explain', 'user.confirmation.sent')
        .fail ->
          App.request('messenger:explain', 'error.unknown')
