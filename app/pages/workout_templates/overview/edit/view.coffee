define [
  './template'
  'features/workout_exercises/view'
  'autosize'
], (
  template
  WorkoutExercisesView
  autosize
) ->

  class WorkoutEditView extends Marionette.View

    key: 'WorkoutEditView'

    template: template

    className: 'gc-box-content workout-template edit'

    behaviors: ->
      video_assigned: true
      delete_button:
        enabled: @_enabled
        short: true
      privacy_toggle2:
        enabled: ->
          @view.options.model.type is 'WorkoutTemplate' and
          App.request('current_user').get('can_manage_privacy')

      stickit:
        bindings:
          '.workout-name input': 'name'
          '.workout-description textarea':
            observe: 'description'
            afterUpdate: ->
              autosize.update(@$('textarea'))
          '.gc-nav-wrapper':
            observe: 'id'
            visible: ->
              @model.type is 'WorkoutTemplate'
          '.name-label':
            observe: ['is_warmup', 'is_cooldown']
            onGet: ([is_warmup, is_cooldown]) ->
              return 'Warmup Name' if is_warmup
              return 'Cooldown Name' if is_cooldown
              'Workout Name'
          '.description-label':
            observe: ['is_warmup', 'is_cooldown']
            onGet: ([is_warmup, is_cooldown]) ->
              return 'Warmup Description' if is_warmup
              return 'Cooldown Description' if is_cooldown
              'Workout Description'

      regioned:
        views: [
            region: 'workout_exercises'
            klass: WorkoutExercisesView
            options: ->
              model: @model
              collection: @model.exercises
            enabled: ->
              @model.type is 'PersonalWorkout'
        ]

    events:
      'click .btn.save': '_saveOnExit'

    _attrs: ['name', 'description']

    _enabled: ->
      can('update', @view.options.model)

    initialize: ->
      @oldAttrs = @model.pick(@_attrs...)
      @listenTo(@, 'childview:video:assign', @_videoAssign)

    onAttach: ->
      autosize(@$('textarea'))

    onBeforeDestroy: ->
      isChanged = _.some(@oldAttrs, (val, key) => @model.get(key) isnt val)
      return unless isChanged
      @_saveOnExit() if confirm('Save your data before you leave this page?')

    onDestroy: ->
      autosize.destroy(@$('textarea'))
      @model.set(@oldAttrs, silent: true)

    _saveOnExit: ->
      @oldAttrs = @model.pick(@_attrs...)
      @model.save().then =>
        rootUrl = if @model.get('is_warmup')
          'warmups'
        else if  @model.get('is_cooldown')
          'cooldowns'
        else
          _.chain(@model.type).pluralize().underscored().value()
        path = [rootUrl, @model.id, 'overview']
        App.vent.trigger('redirect:to', path)

    _videoAssign: ->
      App.request('modal:video:assign', @model)
