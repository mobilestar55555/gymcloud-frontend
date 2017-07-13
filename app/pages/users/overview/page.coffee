define [
  'pages/base/page'
  './template'
  'models/client'
  'features/profile/header/view'
  'features/profile/personal_assignments/view'
  'features/profile/personal_exercises/view'
  'features/profile/activity/view'
  'features/video_library/view'
], (
  BasePage
  template
  Client
  HeaderView
  AssignedTemplatesLayoutView
  PersonalExercisesLayoutView
  ActivityView
  VideoLibrary
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    behaviors:

      navigation_content_tabs:
        data: [
            id: 'programs'
            title: 'Programs'
          ,
            id: 'workouts'
            title: 'Workouts'
          ,
            id: 'warmups'
            title: 'Warmups'
          ,
            id: 'cooldowns'
            title: 'Cooldowns'
          ,
            id: 'exercises'
            title: 'Exercises'
          ,
            id: 'videos'
            title: 'Videos'
        ]

      regioned:
        views: [
            region: 'header'
            klass: HeaderView
            options: ->
              model: @model.get('data.model')
          ,
            region: 'activity'
            klass: ActivityView
            options: ->
              user: @model.get('data.model')
        ]

      stickit:
        bindings: ->
          '.gc-content-nav-add .title':
            observe: 'state.subpage'
            onGet: (value) ->
              entityName = _.singularize(value)
              "Add #{entityName}"

    events:
      'click .gc-content-nav-delete': '_deleteButtonClick'
      'click .gc-content-nav-add': '_assignNewOne'

    initModel: ->
      user = App.request('current_user')
      user.clients.get(@options.id) || new Client(id: @options.id)

    initViews: ->
      model = @model.get('data.model')
      assignedTemplatesView = (viewType) ->
        new AssignedTemplatesLayoutView(model: model, viewType: viewType)

      programs: ->
        assignedTemplatesView('personal_programs')
      workouts: ->
        assignedTemplatesView('personal_workouts')
      warmups: ->
        assignedTemplatesView('personal_warmups')
      cooldowns: ->
        assignedTemplatesView('personal_cooldowns')
      exercises: ->
        new PersonalExercisesLayoutView
          model: model
      videos: ->
        new VideoLibrary
          user_id: model.id


    _deleteButtonClick: ->
      view = @getRegion('page_content').currentView
      view.trigger('nav:delete')

    _assignNewOne: ->
      view = @getRegion('page_content').currentView
      view.trigger('nav:assign')
