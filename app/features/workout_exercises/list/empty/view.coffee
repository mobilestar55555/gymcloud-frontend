define ->

  class EmptyWorkoutExerciseView extends Marionette.View

    template: _.noop

    tagName: 'p'

    className: 'gc-workout-global-exercises-empty'

    behaviors:
      stickit:
        bindings:
          ':el':
            observe: ['is_warmup', 'is_cooldown']
            onGet: ([is_warmup, is_cooldown]) ->
              type = 'warmup' if is_warmup
              type = 'cooldown' if is_cooldown
              type ||= 'workout'
              "There are no exercises in this #{type}"
