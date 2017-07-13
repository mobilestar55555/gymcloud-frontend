define [
  'models/exercise'
  'models/workout_template'
  'models/program_template'
  './template'
], (
  Exercise
  WorkoutTemplate
  ProgramTemplate
  template
) ->
  class AddEntityModalView extends Marionette.View

    template: template

    className: 'modal-dialog modal-md'

    ui:
      form: 'form'
      nameInput: '.form-control'

    events:
      'submit @ui.form': 'submitForm'

    behaviors:

      form_validation: true

      stickit:
        bindings:
          '[data-bind="name"]': 'name'

    templateContext: ->
      singularName: _.chain(@type).humanize().singularize().value()

    initialize: (data) =>
      @type = data.type
      @folder = data.folder
      Klass = @_getModelClass(data.type)
      @model = new Klass(folder_id: @folder.get('id'))
      @model.set(is_warmup: true) if @type is 'warmups'
      @model.set(is_cooldown: true) if @type is 'cooldowns'
      @model.set('name', data.name) if @options.name
      @submitForm() if @options.name
      @listenTo(@model, 'error', @_onSyncFail)

    onRender: =>
      setTimeout ( =>
        @getUI('nameInput').focus()
      ), 400

    submitForm: (ev) =>
      @model.save().then =>
        user = App.request('current_user')
        collection = user[@type]
        collection.add(@model)
        @folder.items.add(@model)
        @_showSuccessMessage()
        App.vent.trigger('mixpanel:track', "#{@type}_created", @model)
        @$el.parent().one 'hidden.bs.modal', =>
          App.vent.trigger('redirect:to', [@type, @model.id], replace: false)
        @$el.parent().modal('hide')
        if @options.name
          App.vent.trigger('redirect:to', [@type, @model.id], replace: false)

    _showSuccessMessage: ->
      App.request('messenger:explain', 'item.added')

    _onSyncFail: (model, data) ->
      for name, error_msg of data.error
        $input = @$el.find("input[name=#{name}]")
        $inputGroup = $input.closest('.form-group')
        @trigger 'switchError', error_msg[0], $inputGroup

    _getModelClass: (type) ->
      {
        exercises: Exercise
        workout_templates: WorkoutTemplate
        warmups: WorkoutTemplate
        cooldowns: WorkoutTemplate
        program_templates: ProgramTemplate
      }[type]
