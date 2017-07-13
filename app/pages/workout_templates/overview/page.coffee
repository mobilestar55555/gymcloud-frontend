define [
  'pages/base/page'
  './template'
  'models/workout_template'
  'features/assignment_list/view'
  './overview/view'
  './nested_workout/view'
  './edit/view'
], (
  BasePage
  template
  WorkoutTemplate
  AssignView
  OverviewView
  WarmupCooldownView
  EditView
) ->

  class Page extends BasePage

    behaviors: ->

      toggleLabel = (model, label) ->
        isnt_workout = model.get('is_warmup') or model.get('is_cooldown')
        label.set(hidden: isnt_workout)

      enabledFn = (view, model, label) ->
        toggleLabel(model, label)
        view.listenToOnce model, 'change:is_warmup change:is_cooldown', ->
          toggleLabel(model, label)

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')
        editable: false

      navigation_content_tabs:
        data: [
            id: 'overview'
            title: 'Overview'
          ,
            id: 'warmup'
            title: 'Warmup'
            enabled: _.partial(enabledFn, @, @model.get('data.model'))
          ,
            id: 'cooldown'
            title: 'Cooldown'
            enabled: _.partial(enabledFn, @, @model.get('data.model'))
          ,
            id: 'assign'
            title: 'Assign'
        ]

      redirect_back_on_destroy:
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new WorkoutTemplate(id: @options.id)

    originalModel: ->
      user = App.request('current_user')
      model = user.workout_templates?.get(@options.id)
      model ||= user.warmups?.get(@options.id)
      model ||= user.cooldowns?.get(@options.id)

    originalAttrsToListen: ->
      ['name', 'updated_at', 'folder_id', 'is_public']

    initViews: ->
      model = @model.get('data.model')
      overview: ->
        new OverviewView
          model: model
      warmup: ->
        new (WarmupCooldownView('warmup'))
          model: model
      cooldown: ->
        new (WarmupCooldownView('cooldown'))
          model: model
      edit: ->
        new EditView
          model: model
      assign: ->
        new AssignView
          model: model

    onAttach: ->
      dataModel = @model.get('data.model')
      @listenTo(dataModel, 'change:user_id', @_changeContentTabsVisibility)
      @_redirectToEditIfNew()

    _changeContentTabsVisibility: ->
      if can('update', @model.get('data.model'))
        @navigation_content_tabs.$el.show()
      else
        @navigation_content_tabs.$el.hide()

    _redirectToEditIfNew: ->
      model = @model.get('data.model')
      return unless model.get('created_at') is model.get('updated_at')
      setTimeout =>
        @model.set('state.subpage', 'edit')
        path = ['workout_templates', @options.id, 'edit']
        App.vent.trigger('redirect:to', path, trigger: false, replace: false)
      , 10