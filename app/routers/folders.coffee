define [
  'features/folders/view'
], (
  FoldersView
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'exercises_folder(/:id)': 'exercises'
      'workout_templates_folder(/:id)': 'workout_templates'
      'warmups_folder(/:id)': 'warmups'
      'warmup_templates_folder(/:id)': 'warmups'
      'cooldowns_folder(/:id)': 'cooldowns'
      'cooldown_templates_folder(/:id)': 'warmups'
      'program_templates_folder(/:id)': 'program_templates'

  class Controller extends Marionette.Controller

    exercises: (id) ->
      @_showFolderView('exercises', id)

    workout_templates: (id) ->
      @_showFolderView('workout_templates', id)

    warmups: (id) ->
      @_showFolderView('warmups', id)

    cooldowns: (id) ->
      @_showFolderView('cooldowns', id)

    program_templates: (id) ->
      @_showFolderView('program_templates', id)

    _showFolderView: (type, id) ->
      user = App.request('current_user')
      id ||= user.library.first().id
      folders = user.folders
      folder = folders.get(id)
      view = new FoldersView
        model: folder
        items: folder.items
        type: type
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
