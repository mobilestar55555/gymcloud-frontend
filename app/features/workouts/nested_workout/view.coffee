define [
  './template'
  './styles'
  'features/workout_exercises/view'
  'features/personal_workout_exercises/view'
  'features/quick_add/view'
], (
  template
  styles
  WorkoutExercisesView
  ReadableWorkoutExercisesView
  QuickAddView
) ->

  (type) -> #warmup/cooldown

    unless _.contains(['warmup', 'cooldown'], type)
      throw Error("unknown nested workout type: #{type}")
    cType = _.capitalize(type) #capitalized

    class WarmupCooldownOverviewView extends Marionette.View

      className: styles.overview

      template: template

      templateContext:
        s: styles
        type: type

      regions:
        exercises_constructor: 'region[data-name="exercises_constructor"]'

      behaviors: ->
        stickit:
          bindings:
            ':el':
              classes:
                "#{styles.nonexistent}":
                  observe: "#{type}_id"
                  onGet: (value) ->
                    !value
            ".#{styles.empty}":
              observe: "#{type}_id"
              visible: (value) ->
                !value
            ".#{styles.overview}":
              observe: "#{type}_id"
              visible: (value) ->
                !!value

        regioned:
          views: [
              region: 'quick_add'
              klass: QuickAddView
              replaceElement: true
              options: ->
                collection: App.request('current_user')["#{type}s"]
                typeToAdd: cType
                newButtonName: "Add #{cType}"
                isIconHidden: true
              enabled: ->
                !@options.readonly
          ]

      initialize: ->
        @nested = new @model.constructor
        @_fetchNested()
        @listenTo(@model, "change:#{type}_id", @_fetchNested)
        @listenTo(@nested, 'sync', @_renderWorkoutExercises)

      onAttach: ->
        @listenTo(@views.quick_add, 'quick_add:chosen', @_setNested)
        @_renderWorkoutExercises() if @nested._isSynced

      _fetchNested: ->
        prevId = @nested.id
        @nested.set(id: @model.get("#{type}_id"))
        @nested.fetch() if @nested.id and @nested.id isnt prevId

      _renderWorkoutExercises: ->
        View = if can('update', @model) and !@options.readonly
          WorkoutExercisesView
        else
          ReadableWorkoutExercisesView
        view = new View
          blue_header: true
          model: @nested
          collection: @nested.exercises
        @showChildView('exercises_constructor', view)
        view.listenTo(view, "remove:#{type}", _.bind(@_setNested, @, null))

      _setNested: (value) ->
        @model.save({"#{type}_id": value}, wait: true)
