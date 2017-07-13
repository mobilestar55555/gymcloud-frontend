define [
  'backbone'
  'models/workout_template'
  'models/program_template'
  'collections/folder_items'
], (
  Backbone
  WorkoutTemplate
  ProgramTemplate
  FolderItems
)->

  Exercise = Backbone.Model

  class Folder extends Backbone.Model

    type: 'Folder'

    computed: ->
      link:
        depends: ['id']
        get: (attrs) ->
          "##{@items.type}_folder/#{attrs.id}"
        toJSON: false

    constructor: (_attributes, _collectionOptions) ->
      @items = new FolderItems
      @nestedFolders = new Backbone.VirtualCollection @items,
        filter: (model) ->
          _.isUndefined(model.get('folder_id'))
      @nestedEntities =  new Backbone.VirtualCollection @items,
        filter: (model) ->
          !_.isUndefined(model.get('folder_id'))

      super

    initialize: (options) ->
      @_defineParent()
      @computedFields = new Backbone.ComputedFields(@)

    urlRoot: '/folders'

    validation:
      name:
        required: true

    nestedFolders: ->
      new Backbone.Collection @items.filter (model) ->
        _.isUndefined(model.get('folder_id'))

    nestedEntities: ->
      new Backbone.Collection @items.filter (model) ->
        !_.isUndefined(model.get('folder_id'))

    parse: (data, options) ->
      if data.items
        if data.parent_id == null
          data = @_parseRootFolder(data)
        else
          data = @_parseFolder(data, options.type)
        @items.reset(data.items)
        delete data.items
      data

    _parseRootFolder: (data) ->
      data.items = _.map data.items, (folder) =>
        attrs = @_parseFolder(folder, folder.name)
        folderModel = @_createFolderFromAttrs(attrs, folder.name)
      data

    _parseFolder: (folderAttrs, type) ->
      folderAttrs.items = _.map folderAttrs.items, (entity) =>
        if entity.folder_id
          @_parseEntity(entity, type)
        else
          attrs = @_parseFolder(entity, type)
          folderModel = @_createFolderFromAttrs(attrs, type)

      folderAttrs

    _createFolderFromAttrs: (attrs, type) ->
      user = App.request('current_user')
      collection = user.folders
      items = attrs.items
      delete attrs.items
      folder = collection.get(attrs.id)
      unless folder
        folder = new Folder(attrs, parse: true)
        collection.add(folder, merge: true)
      itemsType = @_getItemCollectionAttributes(type).collectionName
      folder.items.reset(items)
      folder.items.type = itemsType
      folder.trigger('change:id')
      folder

    _parseEntity: (modelAttrs, type) ->
      user = App.request('current_user')
      collectionName = @_getItemCollectionAttributes(type).collectionName
      collection = user[collectionName]
      model = collection?.get(modelAttrs.id)
      unless model
        ModelClass = @_getItemCollectionAttributes(type).modelClass
        model = new ModelClass(modelAttrs, parse: true)
        collection.add(model, merge: true)
      model

    _getItemCollectionAttributes: (folder_name) ->
      {
        Exercises:
          collectionName: 'exercises'
          modelClass: Exercise
        'Workout Templates':
          collectionName: 'workout_templates'
          modelClass: WorkoutTemplate
        'Warmup Templates':
          collectionName: 'warmups'
          modelClass: WorkoutTemplate
        'Cooldown Templates':
          collectionName: 'cooldowns'
          modelClass: WorkoutTemplate
        'Program Templates':
          collectionName: 'program_templates'
          modelClass: ProgramTemplate
      }[folder_name] || {
        collectionName: 'other'
        modelClass: Backbone.Model
      }

    _defineParent: ->
      @__defineGetter__ 'parent', ->
        user = App.request('current_user')
        collection = user.folders
        collection.get(@get('parent_id'))
