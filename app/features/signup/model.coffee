define [
  'models/auth/login-model'
], (
  LoginModel
) ->

  class AccountModel extends Backbone.Model

    urlRoot: '/users.json'

    defaults:
      first_name: undefined
      last_name: undefined
      email: undefined
      password: undefined
      password_confirmation: undefined
      user_profile_id: undefined
      is_pro: false

    validation:

      first_name:
        required: true

      last_name:
        required: true

      email:
        required: true
        pattern: 'email'

      password:
        required: true
        minLength: 6
        msg: 'must be 6 characters'

      password_confirmation: [
          equalTo: 'password'
          msg: 'do not match'
        ,
          required: true
          minLength: 6
          msg: 'must be 6 characters'
      ]

      agreement:
        acceptance: true
        msg: 'You should Agree with the GymCloud End User Agreement'

    computed: ->
      is_client:
        depends: ['is_pro']
        get: (attrs) ->
          !attrs['is_pro']
        toJSON: true

    initialize: (data) ->
      @computedFields = new Backbone.ComputedFields(@)
      @set(is_pro: _.contains(['true', true], data.is_pro))

    createAccount: ->
      defer = new $.Deferred

      unless @isValid(true)
        error = responseJSON: {error: @validate()}
        setTimeout (-> defer.reject(error)), 1
        return defer.promise()

      $.post('/users.json', JSON.stringify(@_prepareInitialParams()))
        .then (user) =>
          # set created id and user_profile_id
          @set
            id: user.id
            user_profile_id: user.user_profile.id
            payment_bypass: user.payment_bypass
            is_promoted: user.is_promoted

          @_login(defer)

        .fail(defer.reject)

      defer.promise()

    acceptInvite: ->
      defer = new $.Deferred

      unless @isValid(true)
        error = responseJSON: {error: @validate()}
        setTimeout (-> defer.reject(error)), 1
        return defer.promise()

      $.ajax(
        url: '/users/invitation.json'
        data: JSON.stringify(@_prepareInviteParams())
        type: 'PUT'
      ).then =>
        @_login(defer)

      defer.promise()

    _login: (defer) ->
      # get the token once the account is created
      loginModel = new LoginModel
        username: @get('email')
        password: @get('password')

      loginModel.once('model:login:fail', defer.reject)

      loginModel.once 'model:login:success', (response) =>
        App.request('accessToken:set', response.access_token)
        # App.request('current_user').fetch()

        # update user profile once access token is received
        @_updateUserProfile @get('user_profile_id'), (profileResponse) =>
          defer.resolve(response, profileResponse)
          @trigger('account:created', response, profileResponse)

      loginModel.login()

    # Initial request payload should only include
    _prepareInitialParams: ->
      toInclude = ['email', 'password', 'is_pro', 'is_client', 'promo_code']
      user: _.pick(@attributes, toInclude)

    # once account is created, update user_profile
    _preparePatchParams: ->
      params = _.pick(@attributes, 'first_name', 'last_name')

      # rename proper keys for user_profile request
      params.user_id = @get('id')
      params.id = @get('user_profile_id')
      params

    _prepareInviteParams: ->
      params = @_prepareInitialParams()
      params.user.invitation_token = @get('invitation_token')
      params

    # update user profile using patch
    _updateUserProfile: (user_profile_id, doneCallback) =>
      $.ajax
        url: "/user_profiles/#{user_profile_id}"
        data: JSON.stringify(@_preparePatchParams())
        type: 'PATCH'
      .then(doneCallback)
