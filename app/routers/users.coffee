define [
  'features/new_profile_view/view'
  'pages/users/overview/page'
  'pages/personal_exercises/overview/page'
  'models/user'
], (
  NewProfileView
  OverviewPage
  PersonalExercisePage
  UserModel
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'users/me(/)': 'myProfile'
      'users/me/edit': 'editMyProfile'
      'users/:id': 'root'
      'users/:id/edit': 'editUserProfile'
      'users/:id/:state': 'overview'
      'users/:id/exercises/:exercise_id': 'personalExercise'

  class Controller extends Marionette.Controller


    root: (id) ->
      path = ['users', id, 'programs']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new OverviewPage
        id: id
        state: state

    myProfile: ->
      user = App.request('current_user')
      @root(user.id)

    editMyProfile: ->
      user = App.request('current_user')
      @_editUserProfile(user)

    editUserProfile: (id) ->
      user = App.request('current_user').clients.get(id)
      user ||= new UserModel(id: id)
      @_editUserProfile(user)

    personalExercise: (userId, exerciseId) ->
      currentUser = App.request('current_user')
      user = currentUser.clients?.get(userId) or new UserModel(id: userId)
      new PersonalExercisePage
        id: exerciseId
        user: user
        state: 'overview'

    _editUserProfile: (user) ->
      user.fetch()
      view = new NewProfileView
        model: user.user_profile
        user: user
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
