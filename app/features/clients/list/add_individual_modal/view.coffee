define [
  './template'
], (
  template
) ->
  class AddIndividualModal extends Marionette.View

    key: 'AddIndividualModal'

    template: template

    className: 'modal-dialog gc-client-modal'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          'input[name="email"]': 'email'
          'input[name="first_name"]': 'first_name'
          'input[name="last_name"]': 'last_name'

    ui:
      form: 'form'

    events:
      'submit @ui.form': 'submitForm'
      'click button[data-action="invite"]': 'saveAndInvite'
      'blur form input': 'validateInput'

    templateContext: ->
      clientType: @options.clientType

    initialize: ->
      Backbone.Validation.bind @

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $input.attr 'name'
      input_value = $input.val()
      $inputGroup = $input.closest('.form-group')
      error_msg = @model.preValidate input_name, input_value
      @trigger 'switchError', error_msg, $inputGroup

    saveAndInvite: ->
      @model.set('invite', true)
      @submitForm()

    submitForm: ->
      return unless @model.isValid
      @model.save()
        .then =>
          @collection.add(@model)
          App.request('messenger:explain', 'client.added')
          App.vent.trigger('mixpanel:track', 'client_added', @model)
          @inviteClient() if @model.get('invite')
          @trigger 'close:modal'
        .fail(@onRequestFail)

    inviteClient: ->
      @model.invite(@model.get('email'))
        .then =>
          App.request('messenger:explain', 'user.invitation.sent')
          App.vent.trigger('mixpanel:track', 'client_invited', @model)
        .fail(@onRequestFail)

    onRequestFail: (xhr, error, errorType) ->
      try
        errorObj = xhr.responseJSON.error
        errors = _.map(errorObj, (v, k) -> "#{_.humanize(k)}: #{v.join(', ')}")
        message = errors.join('; ')
      catch error
        message = xhr.responseText or errorType
      App.request('messenger:explain', 'message.error', message: message)