define [
  'features/dashboard/info_tables/view'
  './clients/view'
  './groups/view'
  './template'
], (
  InfoTablesView
  AssignClientsListView
  AssignGroupsListView
  template
) ->

  class AssignView extends Marionette.View

    template: template

    behaviors: ->
      regioned:
        views: [
            region: 'clients_and_groups'
            klass: InfoTablesView
            options: ->
              model = @model
              collection: @assignments
              tables: [
                  name: 'individuals'
                  region: 'individuals'
                  klass: AssignClientsListView
                  options: ->
                    collection: App.request('current_user').clients
                    clientAssignees: model.assignees
                    entity: model
                ,
                  name: 'groups'
                  region: 'groups'
                  klass: AssignGroupsListView
                  options: ->
                    collection: model.group_assignments
                    entity: model
              ]
        ]

    initialize: ->
      @assignments = new Backbone.Collection
      @_emulateRequestStarted()
      return @_emulateRequestFinished() unless @model.fetchAssignments
      @model.fetchAssignments()
        .then =>
          @_emulateRequestFinished()

    _emulateRequestStarted: (collection) ->
      @assignments._isRequested = true
      @assignments.url = '/'

    _emulateRequestFinished: (collection) ->
      @assignments._isRequested = false
      @assignments._isSynced = true
      @assignments.url = undefined
      @assignments.trigger('sync')
