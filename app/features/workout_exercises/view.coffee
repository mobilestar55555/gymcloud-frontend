define [
  './template'
  './styles'
  './list/view'
  './actions/view'
], (
  template
  styles
  ListView
  ActionsView
) ->

  class WorkoutExercisesListView extends Marionette.View

    className: 'gc-workouts-exercises-view'

    template: template

    templateContext:
      s: styles

    behaviors:

      stickit:
        bindings:
          '.blue-header':
            observe: 'blue_header'
            visible: true
          '.name':
            observe: 'name'
            events: ['blur', 'change']

      regioned:
        views: [
            region: 'workout_exercises_list'
            klass: ListView
          ,
            region: 'workout_exercises_actions'
            klass: ActionsView
            replaceElement: true
            enabled: ->
              can('update', @model)
        ]

    events:
      'keypress .name': '_handleKeyPress'
      'paste .name': '_handlePaste'
      'blur .name': '_saveName'
      'change .name': '_saveName'
      'click [data-action="save_warmup_in_library"]': '_saveWarmupInLibrary'
      'click [data-action="remove_warmup_from_workout"]': '_removeWarmup'
      'click [data-action="save_cooldown_in_library"]': '_saveCooldownInLibrary'
      'click [data-action="remove_cooldown_from_workout"]': '_removeCooldown'

    initialize: ->
      @model.set(blue_header: !!@options.blue_header)
      @listenTo(@collection, 'reset add remove', @_actionsVisibility)

    onAttach: ->
      App.request 'fwd',
        context: @
        from: @views.workout_exercises_actions
        to: @views.workout_exercises_list
        events: [
          'actions:add'
          'actions:create'
          'actions:multi_constructor:start'
          'actions:multi_constructor:stop'
          'actions:multi_constructor:assign'
        ]
      App.request 'fwd',
        context: @
        from: @
        to: @views.workout_exercises_actions
        events: [
          'actions:hide'
          'actions:show'
        ]

      @listenTo @views.workout_exercises_list, 'edited', => @trigger('edited')

      @listenToOnce @views.workout_exercises_actions, 'attach',
        @_actionsVisibility

    _actionsVisibility: ->
      if @collection.length > 1
        @trigger 'actions:show'
      else
        @trigger 'actions:hide'


    _handlePaste: (ev) ->
      ev.preventDefault()
      data = ev.clipboardData ||
        ev.originalEvent.clipboardData ||
        window.clipboardData
      value = data
        .getData('text')
        .replace(/[\n|\r]/ig, '')
      @model.set(name: value)
      false

    _handleKeyPress: (ev) ->
      @_saveName(ev) if ev.which is 13

    _saveName: (ev) ->
      ev.preventDefault()
      ev.currentTarget.blur()
      setTimeout((=> @model.save()), 200)
      window.getSelection().removeAllRanges()
      false

    _saveWarmupInLibrary: ->
      @_saveInLibrary('Warmup')

    _saveCooldownInLibrary: ->
      @_saveInLibrary('Cooldown')

    _saveInLibrary: (type) ->
      user = App.request('current_user')
      folder = user.getRootFolderFor("#{type} Templates")
      folderItems = folder.items
      id = if @model.type is 'WorkoutTemplate'
        @model.get('id')
      else
        @model.get('workout_template_id')
      folderItems.duplicate(
        ids: [id]
        foldersIds: [folder.get('id')]
      ).then ->
        App.request('messenger:explain', 'program_workout.saved')

    _removeWarmup: ->
      @trigger('remove:warmup')

    _removeCooldown: ->
      @trigger('remove:cooldown')
