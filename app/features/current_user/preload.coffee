define [
  'collections/user_collection'
  'models/user'
  'models/client_group'
  'models/personal_property'
  'models/folder'
], (
  UserCollection
  User
  ClientGroup
  PersonalProperty
  Folder
)->

  (user) ->

    collections =
      exercises: Backbone.Model
      workout_templates: Backbone.Model
      warmups: Backbone.Model
      cooldowns: Backbone.Model
      program_templates: Backbone.Model
      folders: Folder
      library: Folder
      pros: User
      clients: User
      client_groups: ClientGroup
      personal_properties: PersonalProperty
      workout_exercises: Backbone.Model
      personal_warmups: Backbone.Model
      personal_workouts: Backbone.Model
      personal_cooldowns: Backbone.Model
      personal_programs: Backbone.Model
      notifications: Backbone.Model
      personal_exercises: Backbone.Model
      # workout_events: Backbone.Model

    if not user.get('is_pro')
      toExclude = [
        'clients'
        'client_groups'
        'exercises'
        'folders'
        'personal_properties'
        'library'
      ]
      for key in toExclude
        delete collections[key]

    requiredToStart = [
      'exercises'
      'workout_templates'
      'warmups'
      'cooldowns'
      'program_templates'
      'folders'
      'library'
      'personal_properties'
      'clients'
    ]

    promises = _.map collections, (model, item) ->
      collection = new UserCollection [],
        model: model
        user: user
        type: item
      user.__defineGetter__(item, -> collection)

      return collection.fetch() unless user.get('is_pro')
      if _.include(requiredToStart, item) then collection.fetch() else null

    promises = _.compact(promises)
    notRequired = _.difference(_.keys(collections), requiredToStart)
    $.when(promises...).then ->
      return unless user.get('is_pro')
      setTimeout (->
        _.each(notRequired, (name) -> user[name].fetch())
      ), 1000

    promises
