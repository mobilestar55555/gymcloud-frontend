define [
  './template'
  'features/quick_add/view'
  'features/exercise_properties/multi_constructor/view'
  '../add_move_modal/view'
  'models/exercise'
], (
  template
  QuickAddView
  ExercisePropertiesMultiConstructor
  AddMoveModal
  Exercise
) ->

  class View extends Marionette.View

    key: 'WorkoutExercisesActionsView'

    template: template

    className: 'gc-exercises-list-actions'

    behaviors: ->

      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            replaceElement: true
            options: ->
              collection: App.request('current_user').exercises
              typeToAdd: 'Exercise'
            enabled: ->
              can('update', @model)
          ,
            region: 'exercise_properties_multi_construtor'
            replaceElement: true
            klass: ExercisePropertiesMultiConstructor
            options: -> {}
        ]

    onAttach: ->
      @listenTo @views.quick_add, 'quick_add:chosen', (id) =>
        if id is '0'
          @_showAddMoveModal()
        else
          @trigger('actions:add', id)

      App.request 'fwd',
        context: @
        from: @views.exercise_properties_multi_construtor
        to: @
        prefix: 'actions'
        events: [
          'multi_constructor:start'
          'multi_constructor:stop'
          'multi_constructor:assign'
        ]

      App.request 'fwd',
        context: @
        from: @
        to: @views.exercise_properties_multi_construtor
        events: [
          'actions:show'
          'actions:hide'
        ]

    _showAddMoveModal: ->
      user = App.request('current_user')
      rootFolder = user.getRootFolderFor('exercises')
      view = new AddMoveModal
        model: new Exercise
        collection: rootFolder.nestedFolders
        rootFolderId: rootFolder.id
        folders: user.folders
        exercises: user.exercises

      view.listenToOnce view, 'close:modal', (id) =>
        region.$el.modal('hide')
        @trigger('actions:add', id)
      region = App.request('app:layouts:base').getRegion('modal')
      region.show(view)
      region.$el.modal('show')
