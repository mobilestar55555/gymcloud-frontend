define [
  './template'
], (
  template
) ->

  class ClientGroupHeaderView extends Marionette.View

    id: 'client-header-region'

    template: template

    behaviors:

      stickit:
        bindings:
          '.gc-usercard-name': 'name'
          '.gc-usercard-avatar-wrapper':
            classes:
              'gc-usercard-avatar-exist':
                observe: 'avatar_url'
          'input.gc-usercard-link':
            observe: 'id'
            onGet: (value) ->
              loc = window.location
              "#{loc.protocol}//#{loc.host}/#client_groups/#{value}"
          '.gc-usercard-avatar img':
            attributes: [
              name: 'src'
              observe: 'avatar'
              onGet: (avatar) ->
                if _.any(avatar?.large.url)
                  avatar.large.url
                else
                  'app/images/logo-big.png'
              ]

    events:
      'click .show-client-form': '_showEditModal'
      'change .upload-avatar': 'showThumbnail'
      'change input[type="file"]': 'uploadAvatar'

    _showEditModal: (ev) ->
      App.request('modal:groups', @model)

    uploadAvatar: ->
      data = new FormData()
      data.append('avatar', $('input[type="file"]')[0].files[0])
      upload = $.ajax
        url: "/client_groups/#{@model.get('id')}/avatar"
        type: 'PATCH'
        data: data
        cache: false
        dataType: 'file'
        processData: false
        contentType: false
      upload.always =>
        @model.fetch()
