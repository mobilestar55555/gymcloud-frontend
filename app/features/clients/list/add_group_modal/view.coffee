define [
  './template'
], (
  template
) ->
  class AddGroupModal extends Marionette.View

    template: template

    className: 'modal-dialog'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          'input[name="name"]': 'name'

    ui:
      form: 'form'
      avatarInput: '.gc-edit-profile-modal-upload-input'
      avatar: '.gc-edit-profile-modal-avatar'

    events:
      'submit @ui.form': 'submitForm'
      'change @ui.avatarInput': 'showThumbnail'
      'blur form input': 'validateInput'

    modelEvents:
      'model:avatar_update:success': 'onAvatarUpdate'

    initialize: ->
      Backbone.Validation.bind @

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $input.attr 'name'
      input_value = $input.val()
      if input_value
        $inputGroup = $input.closest('.form-group')
        error_msg = @model.preValidate input_name, input_value
        @trigger 'switchError', error_msg, $inputGroup

    showThumbnail: (ev) ->
      return unless file = ev.target.files?[0]
      reader = new FileReader()
      reader.onload = (e) =>
        @getUI('avatar').attr('src', e.target.result)
      reader.readAsDataURL(file)

    submitForm: ->
      return unless @model.isValid
      @model.save().then =>
        @collection.add(@model)
        if @getUI('avatarInput')[0].files[0]
          data = new FormData()
          data.append('avatar', @getUI('avatarInput')[0].files[0])
          @model.updateAvatar data
        @trigger 'close:modal'

    onAvatarUpdate: (data) ->
      @model.set 'avatar', data.avatar
