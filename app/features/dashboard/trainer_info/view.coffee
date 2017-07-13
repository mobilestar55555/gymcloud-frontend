define [
  './template'
], (
  template
) ->

  class TrainerInfoView extends Marionette.View

    className: 'trainer-info-block'

    template: template

    behaviors: ->
      stickit:
        bindings:
          '.trainer-link':
            observe: 'full_name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) -> "/#users/#{id}"
            ]
          '.trainer-avatar':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
            ]
          '.trainer-label':
            observe: 'id'
            onGet: ->
              @model.user_settings?.get('user_account_type_name')

    events:
      'click .trainer-message-btn': '_comingSoon'

    _comingSoon: ->
      !App.request('messenger:explain', 'error.messaging_coming_soon')