define [
  './list/view'
  './template'
  'models/program_template'
  'models/workout_template'
], (
  AssignedTemplateListView
  template
  ProgramTemplate
  WorkoutTemplate
) ->

  class AssignedTemplatesLayoutView extends Marionette.View

    key: 'AssignedTemplatesLayoutView'

    template: template

    className: 'gc-exercises-assign'

    behaviors: ->

      stickit:
        bindings:
          'input.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'name'
                onGet: (value) ->
                  name = _.humanize(@options.typeName)
                  "Search through assigned #{name}"
            ]

      regioned:
        views: [
            region: 'list'
            klass: AssignedTemplateListView
            options: ->
              model: @model
              collection: @collection
        ]

      auto_complete:
        onItemAdd: (id, $item, selectize) ->
          App.vent.trigger 'redirect:to', [@options.typeName, id],
            replace: false
          selectize.close()
        collection: =>
          type = @options.typeName
          App.request('current_user')[type]
        serealizeFn: (item) ->
          folder: item.folder?.name
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')

    initialize: ->
      @listenTo(@, 'nav:assign', @_assignNewOne)

    _getTemplateModelClass: (personalName) ->
      {
        workout_templates: WorkoutTemplate
        warmups: WorkoutTemplate
        program_templates: ProgramTemplate
      }[personalName]

    _assignNewOne: ->
      type = _.singularize @options.typeName.split('_')[0]
      username = @model.get('name')
      App.request 'modal:prompt',
        title: "Create new #{type} for #{username}"
        confirmBtn: 'Create'
        confirmCallBack: _.bind(@_assignNewOneConfirmCallBack, @)
        cancelCallBack: -> # nothing

    _assignNewOneConfirmCallBack: (name) ->
      TemplateModel = @_getTemplateModelClass(@options.typeName)
      template = new TemplateModel
        name: name || 'New'
        is_visible: false
        is_warmup: @options.typeName is 'warmups'
      template.save().then =>
        @collection.add(template)
        @model.assign(template.id, TemplateModel.name).then =>
          @model.fetch() # TODO: investigate why is this needed
