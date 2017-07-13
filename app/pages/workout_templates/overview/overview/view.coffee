define [
  './template'
  './styles'
  'features/workout_exercises/view'
  'features/personal_workout_exercises/view'
], (
  template
  styles
  WorkoutExercisesView
  ReadableWorkoutExercisesView
) ->

  class WorkoutOverviewView extends Marionette.View

    key: 'WorkoutOverviewView'

    className: "gc-box-content workout-template #{styles.overview}"

    template: template

    templateContext:
      s: styles

    behaviors:
      author_widget: true
      add_to_library: true
      print_button: true
      video_assigned:
        controls: false

      stickit:
        bindings:
          '.description':
            observe: ['description', 'is_warmup', 'is_cooldown']
            onGet: ([value, is_warmup, is_cooldown]) ->
              type = if is_warmup
                'warmup'
              else if is_cooldown
                'cooldown'
              else
                'workout'
              value or "Add your #{type} description here"
            classes:
              "#{styles.placeholder}":
                observe: 'description'
                onGet: (value) ->
                  !value
          ".#{styles.add_description}":
            observe: 'description'
            visible: (value) ->
              !value
            attributes: [
                name: 'href'
                observe: ['id', 'is_warmup', 'is_cooldown']
                onGet: ([id, is_warmup, is_cooldown]) ->
                  rootUrl = if @model.get('is_warmup')
                              'warmups'
                            else if  @model.get('is_cooldown')
                              'cooldowns'
                            else
                              'workout_templates'

                  "##{rootUrl}/#{id}/edit"
            ]
          '.btn.edit':
            observe: 'author_id'
            visible: ->
              can('update', @model)
            attributes: [
                name: 'href'
                observe: ['id', 'is_warmup', 'is_cooldown']
                onGet: ([id, is_warmup, is_cooldown]) ->
                  rootUrl = if is_warmup
                              'warmups'
                            else if is_cooldown
                              'cooldowns'
                            else
                              'workout_templates'

                  "##{rootUrl}/#{id}/edit"
            ]

    regions:
      exercises_constructor: 'region[data-name="workout_exercises_constructor"]'

    _enabled: ->
      can('update', @view.options.model)

    initialize: ->
      @listenTo(@model, 'sync', @_renderWorkoutExercises)

    onAttach: ->
      @_renderWorkoutExercises() if @model._isSynced

    _renderWorkoutExercises: ->
      View = if can('update', @model)
        WorkoutExercisesView
      else
        ReadableWorkoutExercisesView
      view = new View
        model: @model
        collection: @model.exercises
      @showChildView('exercises_constructor', view)
      view.listenTo(view, 'edited', => @_unlinkFromGroup())

    _unlinkFromGroup: ->
      return unless @model.type is 'PersonalWorkout'
      if @model.get('is_default_for_group')
        @model.save(is_default_for_group: false)
