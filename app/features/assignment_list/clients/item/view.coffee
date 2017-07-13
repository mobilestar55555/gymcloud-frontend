define [
  'models/personal_workout'
  './template'
], (
  PersonalWorkout
  template
) ->

  class ClientItemView extends Marionette.View

    tagName: 'li'

    template: template

    className: 'row gc-workout-client-item'

    events:
      'click': 'toggleAssign'

    assignOptions: [
      'assignment'
      'entity'
      'clientAssignees'
    ]

    behaviors:

      stickit:
        bindings:
          '.glyphicon-ok':
            observe: 'isAssigned'
            attributes: [
              name: 'data-id'
              observe: 'id'
            ]
            visible: (value) ->
              !!value
          '.gc-clients-list-client-link':
            observe: 'full_name'
            onGet: (value) ->
              return 'ME' if @model.id is App.request('current_user_id')
              value

    initialize: (options) ->
      for option in @assignOptions
        @[option] = options[option]
      @model.set('isAssigned', !!@assignment)
      @

    toggleAssign: ->
      if @model.get('isAssigned') then @_unassign() else @_assign()

    _unassign: ->
      @assignment.destroy().then =>
        @assignment = null
        @model.set('isAssigned', false)
        @_toggleAssignSuccess('unassign')

    _assign: ->
      @entity.assignTo(@model).then (response) =>
        @assignment = new PersonalWorkout(response)
        @model.set('isAssigned', true)
        @clientAssignees.add(@assignment)
        @_toggleAssignSuccess('assign')

    _toggleAssignSuccess: (actionType) ->
      type = @entity.type
      if actionType is 'assign'
        App.request('messenger:explain', 'item.client.assigned', type: type)
      else
        App.request('messenger:explain', 'item.client.unassigned', type: type)
      @_mixpanelTrack(actionType)

    _mixpanelTrack: (actionType) ->
      namespace = {
        WorkoutTemplate: 'workout'
        ProgramTemplate: 'program'
      }[@entity.type]
      event = "#{namespace}_#{actionType}ed"
      App.vent.trigger 'mixpanel:track', event, @entity,
        user_id: @model.get('id')
