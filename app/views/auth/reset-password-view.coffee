config = require 'config'

module.exports = class ResetPasswordView extends Marionette.View

  template: require('templates/auth/reset_password')

  behaviors:

    form_validation: true

  ui:
    form: '.gc-reset-password-form'
    passwords: '#password-input, #confirm-password-input'
    submitButton: 'button[type="submit"]'

  events:
    'submit @ui.form': 'submit'
    'keyup @ui.passwords': '_validatePasswords'

  initialize: (data) =>
    @token = data.token
    Backbone.Validation.bind(@)

  _validatePasswords: (event) =>
    id = event.target.id
    value = event.target.value
    if id is 'password-input'
      attrib = 'password'
    else if id is 'confirm-password-input'
      attrib = 'password_confirmation'
    @model.set attrib, value
    @model.isValid(attrib)

    if @model.isValid('password') && @model.isValid('password_confirmation')
      @getUI('submitButton').removeClass('disabled')
    else
      @getUI('submitButton').addClass('disabled')

  submit: (ev) =>
    data = _.extend @getUI('form').serializeObject(),
      reset_password_token: @token
      id: 1 # model is not NEW now

    @model.save data,
      success: (model, data) ->
        App.request('messenger:explain', 'user.password.changed')
        window.location.replace '#login'
      error: (model, xhr, error) =>
        errors = xhr.responseJSON.error
        for key, value of errors
          message = value.join(', ')
          input = @getUI('form').find("input[name='#{key}']")
          uiGroup = input.parents('.form-group')
          @trigger 'switchError', message , uiGroup
        if errors.reset_password_token
          App.request('messenger:explain', 'user.password.invalid_token')
