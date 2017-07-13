define [
  './template'
], (
  template
) ->

  class HeaderView extends Marionette.View

    template: template

    id: 'client-header-region'

    modelEvents:
      'model:invite:success': 'onInvite'
      'model:invite:fail': 'onInviteFail'

    events:
      'submit @ui.inviteForm': 'submitClientForm'
      'show.bs.modal @ui.inviteModal': 'fillClientEmail'

    behaviors: ->

      stickit:
        model: => @model.user_profile
        bindings:
          '.gc-usercard-avatar-wrapper':
            attributes: [
                observe: 'avatar'
                name: 'class'
                onGet: (value) ->
                  'gc-usercard-avatar-exist' if _.any(value.large.url)
            ]
          'img.gc-usercard-avatar':
            attributes: [
                observe: 'avatar'
                name: 'src'
                onGet: (value) ->
                  value.large.url
            ]
          'span[data-bind="location"]': 'location'
          'span[data-bind="zip"]': 'zip'
          'span[data-bind="first_name"]': 'first_name'
          'span[data-bind="last_name"]': 'last_name'
          'dd[data-bind="height"]':
            observe: ['height', 'height_feet', 'height_inches']
            onGet: ([height, feet, inches]) ->
              height and "#{feet}' #{inches}\"" or '-'
          'dd[data-bind="weight"]':
            observe: 'weight'
            onGet: '_formatEmptyValue'
          'dd[data-bind="bodyfat"]':
            observe: 'bodyfat'
            onGet: '_formatEmptyValue'
          'dd[data-bind="gender"]':
            observe: 'gender'
            onGet: '_formatEmptyValue'
          'dd[data-bind="birthday"]':
            observe: 'birthday'
            onGet: (value)->
              date = moment(value)
              if date.isValid() then date.fromNow(true) else '-'
          '.show-client-form':
            attributes: [
              observe: 'id'
              name: 'href'
              onGet: ->
                "#users/#{@model.id}/edit"
            ]
          '.invite-client-button, client-title':
            observe: 'id'
            onGet: ->
              "Invite #{@_clientTitle()}"
          '.client-title-label':
            observe: 'id'
            onGet: ->
              "#{@_clientTitle()}'s email"

    ui:
      inviteButton: '.invite-client-button'
      inviteModal: '#gc-invite-client-modal'
      inviteForm: '.invite-client-form'
      inviteEmail: '.invite-client-form input[name=email]'
      clientFormModal: '#gc-edit-client-modal'

    templateContext: ->
      isMyProfile: @_isMyProfile()

    onBeforeDestroy: ->
      @getUI('clientFormModal').off('hidden.bs.modal')

    _isMyProfile: ->
      @model.get('id') is App.request('current_user_id')

    _clientTitle: ->
      currentUser = App.request('current_user').user_settings
      _.singularize(currentUser.get('clients_title'))

    fillClientEmail: ->
      @getUI('inviteEmail').val @model.get('email')

    submitClientForm: (ev) ->
      formData = @getUI('inviteForm').serializeObject()
      @model.invite(formData.email)
        .then =>
          @getUI('inviteModal').modal('hide')
          App.request('messenger:explain', 'user.invitation.sent')
        .fail (xhr, error, errorType) ->
          try
            error = xhr.responseJSON.error
            message = "email #{error.email.join(', ')}"
          catch error
            message = errorType
          App.request 'messenger:explain', 'message:error',
            message: message

    onInvite: ->
      @getUI('inviteModal').modal('hide')
      App.request('messenger:explain', 'user.invitation.sent')

    onInviteFail: (error) ->
      return unless error

      $input = @getUI('inviteForm').find('input[name=email]')
      $inputGroup = $input.closest('.form-group')
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-error-message').text(error)

    _formatEmptyValue: (value) ->
      _.any(value) && value || '-'
