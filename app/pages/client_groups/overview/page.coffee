define [
  'pages/base/page'
  './template'
  'models/client_group'
  'features/client_groups/show/header/view'
  'features/client_groups/show/clients/view'
  'features/client_groups/show/assigned_templates/view'
], (
  BasePage
  template
  ClientGroupModel
  ClientGroupHeaderView
  MembersView
  AssignedTemplatesLayoutView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    behaviors:

      navigate_back: true

      navigation_content_tabs:
        data: [
            id: 'members'
            title: 'Members'
          ,
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
        ]

      regioned:
        views: [
            region: 'header'
            klass: ClientGroupHeaderView
            options: ->
              model: @model.get('data.model')
        ]

      stickit:
        bindings: ->
          '.gc-content-nav-add .title':
            observe: 'state.subpage'
            onGet: (value) ->
              entityName = _.singularize(value)
              "Add #{entityName}"
          '.gc-content-nav-add':
            observe: 'state.subpage'
            visible: (value) ->
              value isnt 'members'

    events:
      'click .gc-content-nav-delete': '_deleteButtonClick'
      'click .gc-content-nav-add': '_assignNewOne'

    init: ->
      _.defer => @model.set('state.subpage', @options.state)

    initModel: ->
      user = App.request('current_user')
      group = user.client_groups.get(@options.id)
      group || new ClientGroupModel(id: @options.id)

    initViews: ->
      model = @model.get('data.model')
      assignedTemplatesView = (typeName) ->
        new AssignedTemplatesLayoutView
          model: model
          collection: model[_.camelcase(typeName)]
          typeName: typeName

      members: ->
        new MembersView
          model: model
          groupId: model.id
          collection: model.clients
      workouts: ->
        assignedTemplatesView('workout_templates')
      warmups: ->
        assignedTemplatesView('warmups')
      cooldowns: ->
        assignedTemplatesView('cooldowns')
      programs: ->
        assignedTemplatesView('program_templates')

    _deleteButtonClick: ->
      view = @getRegion('page_content').currentView
      view.trigger('nav:delete')

    _assignNewOne: ->
      view = @getRegion('page_content').currentView
      view.trigger('nav:assign')