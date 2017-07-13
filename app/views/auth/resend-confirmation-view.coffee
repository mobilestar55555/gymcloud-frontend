module.exports = class ResendConfirmationView extends Marionette.View

  template: require('templates/auth/resend_confirmation')

  modelEvents:
    'model:auth_resend:success': 'onResendSuccess'
    'model:auth_resend:fail': 'onResendFailed'
    'invalid': 'onModelValidateFailed'

  onRender: ->
    Backbone.Validation.bind @

  ui:
    resendButton: 'button.resend-confirmation'
    emailInput: 'input[name=email]'
    resendFormControls: '.gc-resend-form-controls'
    resendSuccess: '.gc-resend-success'
    errorText: '.gc-resend-error-text'

  events:
    'click @ui.resendButton': 'resendInstructions'

  resendInstructions: ->
    @model.set 'email', @getUI('emailInput').val()
    @model.resendConfirmation()

  onResendSuccess: ->
    @getUI('errorText').addClass('hidden')
    @getUI('resendFormControls').addClass 'hidden'
    @getUI('resendSuccess').removeClass 'hidden'

  onResendFailed: (message) ->
    @getUI('errorText').removeClass 'hidden'
    @getUI('errorText').text message

  onModelValidateFailed: (model, error, options) ->
    @displayErrorText error.email

  displayErrorText: (message) ->
    @getUI('errorText').text message
    @getUI('errorText').removeClass 'hidden'
