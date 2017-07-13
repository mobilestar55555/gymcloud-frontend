define [
  'pages/base/page'
  './template'
  'models/personal_workout'
  'pages/workout_templates/overview/edit/view'
], (
  BasePage
  template
  PersonalWorkout
  EditView
) ->

  class Page extends BasePage

    behaviors: ->

      breadcrumbs:
        model: ->
          @view.model.get('data.model')
        editable: false

      navigate_back: true

      mobile_only_features: true

      enter_results_for_new_workout_event:
        id: => @options.id

      stickit:
        model: ->
          @model.get('data.model')
        bindings:
          '.buttons a':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) ->
                  "#personal_workouts/#{id}"
            ]

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    events:
      'click a.btn-warning': '_saveOnExit'

    initModel: ->
      new PersonalWorkout
        id: @options.id

    originalModel: ->
      user = App.request('current_user')
      user.personal_workouts?.get(@options.id)

    originalAttrsToListen: ->
      ['name', 'updated_at']

    initViews: ->
      edit: ->
        new EditView
          model: @model.get('data.model')

    _saveOnExit: (ev) ->
      @getRegion('page_content').currentView._saveOnExit()
      ev
