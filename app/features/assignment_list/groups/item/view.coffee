define [
  'models/personal_workout'
  './template'
], (
  PersonalWorkout
  template
) ->

  class GroupItemView extends Marionette.View

    tagName: 'li'

    template: template

    className: 'row gc-workout-client-item'

    events:
      'click': 'toggleAssign'

    behaviors:

      stickit:
        bindings:
          '.gc-clients-list-avatar-wrapper':
            attributes: [
                observe: 'avatar_background_color'
                name: 'style'
                onGet: (val) ->
                  (val && "background-color: #{val}") || ''
            ]
          '.glyphicon-ok':
            classes:
              partial:
                observe: ['assigned_count', 'clients_count']
                onGet: ([assigned_count, clients_count]) ->
                  assigned_count isnt clients_count
              hidden:
                observe: 'is_assigned'
                onGet: (val) ->
                  !val
          '.assigned_title':
            observe: 'assigned_count'
            visible: true
          '.assigned_count': 'assigned_count'
          '.clients_count': 'clients_count'

    initialize: (options) ->
      @entity = options.entity

    toggleAssign: (ev) =>
      if @model.get('is_assigned')
        type = @entity.type
        App.request 'modal:confirm',
          title: "Unassign #{type}?"
          content: "Are you sure you want unassign #{type} from group?"
          confirmBtn: 'Unassign'
          confirmCallBack: =>
            @model.unassign(@entity.id, @entity.type).then (response) =>
              @model.set(response)
              @_toggleAssignSuccess('unassign')
      else
        @model.assign(@entity.id, @entity.type).then (response) =>
          @model.set(response)
          @_toggleAssignSuccess('assign')

    _toggleAssignSuccess: (actionType) ->
      type = @entity.type
      if actionType is 'assign'
        App.request 'messenger:explain', 'item.client_group.assigned',
          type: type
      else
        App.request 'messenger:explain', 'item.client_group.unassigned',
          type: type
