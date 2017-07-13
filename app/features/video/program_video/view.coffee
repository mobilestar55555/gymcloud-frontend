define [
  './template'
  'features/workouts/nested_workout/view'
], (
  template
  WarmupCooldownPreview
) ->

  class View extends Marionette.View

    template: template

    className: 'gc-program-video'

    behaviors: ->

      editable_textarea:
        readonly: @options.readonly

      video_assigned:
        controls: !@options.readonly

      stickit:
        bindings:
          ':el':
            observe: ['video_url', 'description', 'warmup_id', 'cooldown_id']
            visible: (attributes) ->
              !@options.readonly or _.any(attributes)
          '[data-content="warmup"], [data-content="cooldown"]':
            observe: ['is_warmup', 'is_cooldown']
            visible: (values) ->
              !_.any(values)

      regioned:
        views: [
            region: 'warmup'
            klass: WarmupCooldownPreview('warmup')
            replaceElement: true
            options: ->
              model: @model
              readonly: @options.readonly
          ,
            region: 'cooldown'
            klass: WarmupCooldownPreview('cooldown')
            replaceElement: true
            options: ->
              model: @model
              readonly: @options.readonly
        ]

    ui:
      workoutTabsContent: '.gc-workout-tab-content'

    events:
      'click ul.gc-content-nav li a': '_changeTab'

    onAttach: ->
      @listenToOnce @video_assigned, 'attach', =>
        @listenTo(@video_assigned.currentView, 'video:assign',
          @_showAssignModal)

    _changeTab: (ev) ->
      tabName = $(ev.currentTarget).data('content')
      workoutTabsContent = @getUI('workoutTabsContent')
      workoutTabsContent.find('.tab-pane.active').removeClass('active')
      workoutTabsContent.find("[data-pane='#{tabName}']").addClass('active')

    _showAssignModal: ->
      App.request('modal:video:assign', @model)
