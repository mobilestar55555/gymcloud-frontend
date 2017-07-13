define [
  'pages/base/page'
  './template'
  'models/exercise'
  'features/exercise/overview/view'
  'features/exercise/edit/view'
  'features/video/assignment/view'
], (
  BasePage
  template
  Exercise
  ExerciseOverviewView
  ExerciseEditView
  VideoAssignmentView
) ->

  class Page extends BasePage

    behaviors:
      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')
        editable: false

      redirect_back_on_destroy:
        model: ->
          @view.model.get('data.model')

      stickit:
        bindings:
          '.gc-edit-exercise':
            observe: 'state.subpage'
            visible: (value) ->
              value is 'overview'
          '.gc-save-exercise':
            observe: 'state.subpage'
            visible: (value) ->
              value is 'edit'

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    events:
      'click .gc-edit-exercise': 'edit'
      'click .gc-save-exercise': 'save'

    initModel: ->
      new Exercise(id: @options.id)

    originalModel: ->
      user = App.request('current_user')
      user.exercises?.get(@options.id)

    originalAttrsToListen: ->
      ['name', 'updated_at', 'folder_id', 'is_public']

    initViews: ->
      overview: ->
        view = new ExerciseOverviewView
          model: @model.get('data.model')
        view

      edit: ->
        view = new ExerciseEditView
          model: @model.get('data.model')
        view

    onAttach: ->
      return if /\?back/.test(window.location.hash)
      model = @model.get('data.model')
      if model._isRequested
        @listenToOnce(model, 'sync', => @checkEditState())
      else
        @checkEditState()

    checkEditState: ->
      model = @model.get('data.model')
      return if model.type is 'WorkoutExercise'
      return unless model.get('created_at') is model.get('updated_at')
      @_changeState('edit')

    _changeState: (state) ->
      path = ['exercises', @options.id, state]
      App.vent.trigger('redirect:to', path)

    save: ->
      @model.get('data.model').save()
        .then =>
          view = @getRegion('page_content').currentView
          view.removeListeners()
          view.isChanged = false
          window.history.back() if /\?back/.test(window.location.hash)
          @_changeState('overview')

    edit: ->
      @_changeState('edit')
