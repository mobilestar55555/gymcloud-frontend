define [
  './template'
  './model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class TrainerInviteView extends Marionette.View

    template: template

    behaviors: ->

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings:
          'input[name="name"]': 'name'
          'input[name="email"]': 'email'

    events:
      'submit form': '_onFormSubmit'

    initialize: ->
      @model = new Model

    _onFormSubmit: ->
      @model.save()
        .then (response) =>
          return @_invite() if response.is_new
          App.request('messenger:explain', 'client.pro_exists')
          token = App.request('accessToken:get')
          App.request('auth:onSuccess', {access_token: token})

    _invite: ->
      email = @model.get('email')
      @model.invite(email)
        .then(@_onInvite)

    _onInvite: ->
      App.vent.trigger 'redirect:to', ['auth', 'pro_invite_success'],
        replace: false
