define ->

  class LoginModel extends Backbone.Model

    url: '/oauth/token'

    defaults:
      grant_type: 'password'

    validation:

      username:
        required: true
        pattern: 'email'
        msg: 'Value should be valid email address'

      password:
        required: true

    login: ->
      return unless @isValid

      options = App.request 'ajax:options:create',
        url: @url
        data: JSON.stringify @toJSON()

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger('model:login:success', response)
        .fail (xhr, textStatus, errorThrown) =>
          @trigger('model:login:fail', xhr, textStatus, errorThrown)
