define [
  './concerns/nested_models'
  'collections/workout_exercises'
  'models/user'
], (
  NestedModelsConcern
  WorkoutExercises
  User
) ->

  class PersonalWorkout extends Backbone.Model

    type: 'PersonalWorkout'

    urlRoot: '/personal_workouts'

    constructor: ->
      @__defineGetter__('parent', @_getUser)
      @__defineGetter__('warmup', @_getWarmup)
      @__defineGetter__('cooldown', @_getCooldown)
      @_nestedModelsInit
        exercises: WorkoutExercises
      super

    parse: (data) ->
      @_nestedModelsParseAll(data)
      data

    person: ->
      person_id = @get('person_id')
      App.request('current_user').clients.get(person_id)

    _getUser: ->
      user = new User(id: @get('person_id'))
      user.fetch()
      user

    _getWarmup: ->
      return null if @get('warmup_id')
      warmup = new PersonalWorkout(id: @get('warmup_id'))
      warmup.fetch()
      warmup

    _getCooldown: ->
      return null if @get('cooldown_id')
      cooldown = new PersonalWorkout(id: @get('cooldown_id'))
      cooldown.fetch()
      cooldown

  _.extend(PersonalWorkout::, NestedModelsConcern)

  PersonalWorkout
