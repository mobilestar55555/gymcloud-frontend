define [
  './template'
  'features/workouts/nested_workout/styles'
  '../overview/view'
  'features/workouts/nested_workout/view'
  'models/workout_template'
  'features/workout_exercises/view'
  'features/personal_workout_exercises/view'
  'features/quick_add/view'
], (
  template
  styles
  WorkoutOverview
  NestedWorkout
  WorkoutTemplate
  WorkoutExercisesView
  ReadableWorkoutExercisesView
  QuickAddView
) ->

  (type) -> #nestedWorkoutType

    unless _.contains(['warmup', 'cooldown'], type)
      throw Error("unknown nested workout type: #{type}")
    cType = _.capitalize(type) #capitalized
    ParentView = NestedWorkout(type)

    class NestedWorkoutView extends WorkoutOverview

      key: 'NestedWorkout'

      className: "#{WorkoutOverview::className} #{styles.overview}"

      template: template

      templateContext:
        type: type
        s: WorkoutOverview::templateContext.s
        s2: styles

      behaviors:
        author_widget: true
        add_to_library: true
        print_button: true
        video_assigned:
          controls: false

        stickit:
          bindings: _.extend {}, WorkoutOverview::behaviors.stickit.bindings,
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
          ]

      initialize: ParentView::initialize

      onAttach: ParentView::onAttach

      _fetchNested: ParentView::_fetchNested

      _renderWorkoutExercises: ParentView::_renderWorkoutExercises

      _setNested: ParentView::_setNested
