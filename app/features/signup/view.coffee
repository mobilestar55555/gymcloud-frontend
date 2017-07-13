define [
  './model'
  './template'
  './behavior'
], (
  AccountModel
  template
  AuthBodyClassBehavior
) ->

  class SignupView extends Marionette.View

    template: template

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior
      form_validation: true
      facebook_login:
        isSignup: true
        isLinking: false
      google_login:
        isSignup: true
        isLinking: false

      stickit:
        bindings:
          '[data-bind="first_name"]': 'first_name'
          '[data-bind="last_name"]': 'last_name'
          '[data-bind="password"]': 'password'
          '[data-bind="password_confirmation"]': 'password_confirmation'
          '[data-bind="agreement"]': 'agreement'
          '[data-bind="email"]':
            observe: 'email'
            attributes: [
                name: 'disabled'
                observe: 'invitation_token'
            ]
          '.gc-signup-with-email-title':
            observe: 'is_pro'
            visible: true
          '.gc-login-social':
            observe: 'is_pro'
            visible: true

    ui:
      'form': 'form.gc-signup-form'

    events:
      'submit @ui.form': 'createAccount'
      'blur input': 'validateInput'

    initialize: (options) ->
      Backbone.Validation.bind(@)

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $input.attr('name')
      input_value = $input.val()
      return unless input_value

      $inputGroup = $input.closest('.form-group')
      error_msg = @model.preValidate(input_name, input_value)
      @trigger('switchError', error_msg, $inputGroup)

    createAccount: ->
      # safari autocomplete hack
      fields = [
        'first_name'
        'last_name'
        'email'
        'password'
        'password_confirmation'
      ]

      @model.set _.reduce(fields, ((memo, field) ->
        memo[field] = @$("input[name='#{field}']").val()
        memo
      ), {}, @)
      promo = window.localStorage.getItem('promo_code')
      @model.set(promo_code: promo) if promo
      token = @model.get('invitation_token')
      method = if token then 'acceptInvite' else 'createAccount'
      @model[method]?()
        .then(@onAccountCreateSuccess)
        .fail(@onAccountCreateFail)

    onAccountCreateSuccess: (data, userProfile) =>
      App.request('messenger:explain', 'user.signup.confirm_email')
      user = App.request('current_user')
      user.set
        id: @model.get('id')
        user_profile_id: @model.get('user_profile_id')
        email: @model.get('email')
      user.user_profile.set(userProfile)
      if @model.get('is_pro') or @model.get('invitation_token')
        return App.request('auth:onSuccess', data)
      pathArr = if @model.get('payment_bypass') or @model.get('is_promoted')
                  promo = @model.get('promo_code') || 'payment_bypass'
                  ['auth', 'payment_success', promo]
                else
                  ['auth', 'training_plan']

      App.vent.trigger('redirect:to', pathArr)

    onAccountCreateFail: (xhr, settings, errorThrown)  ->
      errorJSON = xhr.responseJSON.error
      for key of errorJSON
        if errorJSON.hasOwnProperty(key)
          error = errorJSON[key].join?(',') || errorJSON[key]
          errorMsg = "#{_.humanize(key)}: #{error}"
        break

      App.request('messenger:explain', 'message.error', message: errorMsg)
