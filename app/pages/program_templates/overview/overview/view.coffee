define [
  './template'
  'features/program_weeks/list/view'
  'features/program_weeks/list_readable/view'
  'features/program_workouts/list/view'
  'features/program_workouts/list_readable/view'
  './empty/view'
  'models/program_workout'
], (
  template
  ProgramWeeksListView
  ReadableProgramWeeksListView
  ProgramWorkoutsListView
  ReadableProgramWorkoutsListView
  EmptyView
  ProgramWorkout
) ->

  class View extends Marionette.View

    template: template

    className: 'gc-box-content'

    behaviors: ->

      privacy_toggle2:
        enabled: ->
          @view.options.model.type is 'ProgramTemplate' and
          App.request('current_user').get('can_manage_privacy')

      editable_textarea: true

      regioned:
        views: [
            region: 'program_empty'
            klass: EmptyView
            options: ->
              model: @model
        ]

    regions:
      program_weeks: 'region[data-name="program_weeks"]'
      program_workouts: 'region[data-name="program_workouts"]'

    initialize: ->
      @listenToOnce(@model, 'sync', @_fetchWorkouts)

    onAttach: ->
      if !@model.weeks._isSynced or !@model.workouts._isSynced
        @_fetchWorkouts()
      else
        @_renderWorkouts()

    _fetchWorkouts: ->
      dfds = [@model.weeks.fetch(), @model.workouts.fetch()]
      $.when(dfds...).then(=>
        @_renderWorkouts()
        @trigger('workouts:loaded')
      )

    _renderWorkouts: ->
      Views = @_getViews()
      options = @_getViewOptions()

      _.each ['program_weeks', 'program_workouts'], (name) =>
        view = @views[name] = new Views[name](options[name])
        setTimeout (=> view.listenTo(view, 'add:child', @_onAddChild)), 1500
        region = @getRegion(name)
        region?.show(view)

    _getViews: ->
      if can('update', @model)
        program_weeks: ProgramWeeksListView
        program_workouts: ProgramWorkoutsListView
      else
        program_weeks: ReadableProgramWeeksListView
        program_workouts: ReadableProgramWorkoutsListView

    _getViewOptions: ->
      program_weeks:
        collection: @model.weeks
      program_workouts:
        model: @model
        collection: new Backbone.VirtualCollection @model.workouts,
          filter: (model) -> !model.get('week_id')
          comparator: 'position'

    _onAddChild: (childView) ->
      childView.el.scrollIntoViewIfNeeded?()
      childView.$el.addClass('highlight')
      setTimeout (-> childView.$el.removeClass('highlight')), 1500
