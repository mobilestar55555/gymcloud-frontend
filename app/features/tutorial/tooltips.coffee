define ->

  [
      id: 0
      uniq_id: 'folder_list_add_exercise'
      key: 'FolderListView'
      element: (view) -> view.ui.itemAddButton
      rule: -> /\/#exercises/.test(window.location.href)
      main: true
      title: 'Creating An Exercise'
      content: 'Start creating a new exercise by clicking this button.'
      docs: '3000047603--web-trainer-exercises-how-to-create-new'
    ,
      id: 1
      uniq_id: 'folder_list_add_folder'
      key: 'FolderListView'
      element: (view) -> view.ui.folderAddButton
      rule: -> /\/#exercises/.test(window.location.href)
      title: 'Creating An Exercise'
      content: 'Create a new folder by clicking this button.'
      docs: '3000047603--web-trainer-exercises-how-to-create-new'
      placement: 'left'
    ,
      id: 0
      uniq_id: 'exercise_add_description'
      key: 'EditOverviewView'
      element: (view) -> view.$('.description-wrapper')
      rule: -> /\/#exercises\/\d+\/edit/.test(window.location.href)
      main: true
      title: 'Adding Exercise Description'
      content: 'Type the exercise description here.'
      docs: '3000047605--webapp-exercises-how-to-add-descriptions'
    ,
      id: 1
      uniq_id: 'exercise_assign_video'
      key: 'VideoAssignedView'
      element: (view) -> view.ui.buttonAssign
      rule: -> /\/#exercises\/\d+\/edit/.test(window.location.href)
      title: 'Adding An Exercise Video'
      content: 'Click this button to add a video to the exercise.'
      docs: '3000048220--webapp-workouts-how-to-add-a-video'
    ,
      id: 0
      uniq_id: 'workout_template_add_new'
      key: 'FolderListView'
      element: (view) -> view.ui.itemAddButton
      rule: -> /\/#workout_templates/.test(window.location.href)
      main: true
      title: 'Creating A Workout'
      content: 'Add a new workout to your workout library.'
      docs: '3000053516--web-fitpro-workout-templates-how-to-build-a-workout'
    ,
      id: 0
      uniq_id: 'workout_constructor_add_exercise'
      key: 'QuickAddView'
      element: (view) -> view.ui.button
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      main: true
      title: 'Adding Exercises To A Workout'
      content: 'Add exercises to your workout.'
      docs: '3000053516--web-fitpro-workout-templates-how-to-build-a-workout'
    ,
      id: 1
      uniq_id: 'workout_constructor_add_exercise_note'
      key: 'WorkoutExercisesListItemView'
      element: (view) -> view.$('.note-wrapper')
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: 'Adding Workout Notes'
      content: 'Type your workout notes here.'
      docs: '3000053516--web-fitpro-workout-templates-how-to-build-a-workout'
    ,
      id: 2
      uniq_id: 'workout_constructor_add_exercise_property'
      key: 'WorkoutExercisesListItemView'
      element: (view) -> view.ui.addSingleProperty
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: 'Adding Exercise Properties'
      content: '''Hover over exercises and click this button to start adding
                  exercise properties.'''
      docs: '3000053516--web-fitpro-workout-templates-how-to-build-a-workout'
      placement: 'left'
      balloon_pos: 'left'
    ,
      id: 3
      uniq_id: 'workout_constructor_add_exercise_set'
      key: 'WorkoutExercisesListItemView'
      element: (view) -> view.$('.gc-workout-exercise-circle')
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: 'Creating A Set'
      content: '''Change this field to A1 to start creating a set. Label
                  another exercise A2 to include it in the same set.'''
      docs: '3000053516--web-fitpro-workout-templates-how-to-build-a-workout'
      balloon_pos: 'right'
    ,
      id: 0
      uniq_id: 'program_template_add_new'
      key: 'FolderListView'
      element: (view) -> view.ui.itemAddButton
      rule: -> /\/#program_templates/.test(window.location.href)
      main: true
      title: 'Creating A Program'
      content: 'Use this button to add a new program.'
      docs: '3000048794--webapp-programs-how-to-add-new'
    ,
      id: 0
      uniq_id: 'program_constructor_add_week'
      key: 'EditableProgramActionPanel'
      element: (view) -> view.ui.addWeekBtn
      rule: -> /\/#program_templates\/\d+/.test(window.location.href)
      main: true
      title: 'Adding Weeks To A Program'
      content: 'Use this button to add weeks to your program.'
      docs: '3000048884--webapp-programs-how-to-set-weeks'
    ,
      id: 1
      uniq_id: 'program_constructor_add_workout_to_week'
      key: 'EditableProgramActionPanel'
      element: (view) -> view.ui.addWorkoutBtn
      rule: -> /\/#program_templates\/\d+/.test(window.location.href)
      title: 'Adding Workouts To A Program'
      content: 'Use this button to add workouts to your program.'
      docs: '3000048848--webapp-programs-how-to-add-workout'
    ,
      id: 0
      uniq_id: 'clients_add_client_btn'
      key: 'ClientsListView'
      element: (view) -> view.ui.addBtn
      rule: -> /\/#clients\/individuals/.test(window.location.href)
      main: true
      title: 'Adding A Client'
      content: 'Use this button to add a new client to your Client List.'
      docs: '3000048490--web-clients-how-to-add-new'
      onNext: ->
        $('.gc-clients-list-client-actions').first().addClass('visible')
    ,
      id: 1
      uniq_id: 'clients_move_to_group'
      key: 'ClientsListView'
      element: (view) ->
        '.gc-clients-list li:first-child .gc-clients-list-client-move'
      rule: -> /\/#clients\/individuals/.test(window.location.href)
      title: 'Moving A Client To A Client Group'
      content: '''Move a client to a group by simply hovering your mouse over
                  his/her name and using this button.'''
      docs: '''3000048496--webapp-clients-how-to-add-to-group-through-clients
               -list-page'''
      placement: 'left'
      onPrev: ->
        $('.gc-clients-list-client-actions').first().removeClass('visible')
      onNext: ->
        $('.gc-clients-list-client-actions').first().removeClass('visible')
    ,
      id: 0
      uniq_id: 'clients_add_client_enter_name'
      key: 'AddIndividualModal'
      element: (view) -> view.$('.name-wrapper')
      rule: -> /\/#clients\/individuals/.test(window.location.href)
      main: true
      title: 'Adding A Client'
      content: "Enter the client's name here."
      docs: '3000048490--web-clients-how-to-add-new'
      placement: 'bottom'
      onPrev: -> @view.trigger 'close:modal'
    ,
      id: 2
      uniq_id: 'clients_add_client_enter_email'
      key: 'AddIndividualModal'
      element: (view) -> view.$('.email-wrapper')
      rule: -> /\/#clients\/individuals/.test(window.location.href)
      title: 'Adding A Client'
      content: '''Invite your client to GymCloud by entering his/her email
                  address to this box.'''
      docs: '3000048491--web-clients-how-to-register'
    ,
      id: 3
      uniq_id: 'clients_add_save_and_invite'
      key: 'AddIndividualModal'
      element: (view) -> view.$('button[data-action="invite"]')
      rule: -> /\/#clients\/individuals/.test(window.location.href)
      title: 'Adding A Client'
      content: '''Clicking this button will save your client's name and invite
                  him/her to GymCloud.'''
      docs: '3000048491--web-clients-how-to-register'
      onNext: -> @view.trigger 'close:modal'
    ,
      id: 0
      uniq_id: 'clients_create_group'
      key: 'ClientsListView'
      element: (view) -> view.ui.addBtn
      rule: -> /\/#clients\/groups/.test(window.location.href)
      main: true
      title: 'Creating A Client Group'
      content: 'Click this button to start creating a group'
      docs: '3000048495--web-clients-how-to-create-a-group'
    ,
      id: 0
      uniq_id: 'client_tabs'
      key: 'AssignedTemplatesLayoutView'
      element: (view) -> '.gc-content-nav li:first-child'
      rule: -> /\/#users\/\d+\/programs/.test(window.location.href)
      main: true
      title: 'Assigning Items To A Client'
      content: 'Use these tabs to assign a workout or program to your clients.'
      docs: '3000050220--web-clients-how-to-assign-workouts-and-programs'
    ,
      id: 1
      uniq_id: 'client_search_to_assign'
      key: 'AssignedTemplatesLayoutView'
      element: (view) -> view.$('.gc-exercises-assign-input-wrapper')
      rule: -> /\/#users\/\d+\/programs/.test(window.location.href)
      title: 'Assigning Items To A Client'
      content: '''Type here the name of the workout you want to assign and
                  click it.'''
      docs: '3000050220--web-clients-how-to-assign-workouts-and-programs'
    ,
      id: 0
      uniq_id: 'global_search_bar'
      key: 'SearchBarView'
      element: (view) -> view.$('.input-group')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      main: true
      title: 'Global Search Bar'
      content: '''Search here for pre-built Exercise, Workout, and Program
                  Templates.'''
      balloon_pos: 'down'
    ,
      id: 1
      uniq_id: 'help_button'
      key: 'HeaderView'
      element: (view) -> view.$('.gc-help-button')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      title: 'Freshdesk'
      content: '''Got Questions or need help? Access our FAQ or submit a
                  request for support here.'''
      balloon_pos: 'down'
    ,
      id: 2
      uniq_id: 'header_profile_button'
      key: 'HeaderView'
      element: (view) -> view.$('.gc-topbar-avatar')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      title: 'Profile Menu'
      content: 'Keep your members informed by updating your profile.'
      placement: 'left'
      balloon_pos: 'left'
    ,
      id: 3
      uniq_id: 'my_calendar_button'
      key: 'DashboardPage'
      element: (view) -> view.$('.calendar-button')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      title: 'My Calendar'
      content: 'Coming soon.'
    ,
      id: 4
      uniq_id: 'workouts_this_week_tab'
      key: 'InfoTablesView'
      element: (view) -> view.$('.tab-link:first-child')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      title: 'Workouts This Week'
      content: 'Keep track of workouts scheduled for your clients this week.'
    ,
      id: 5
      uniq_id: 'client_perfomance_tab'
      key: 'InfoTablesView'
      element: (view) -> view.$('.tab-link:nth-child(2)')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      title: 'Workout Frequency Tracking'
      content: '''Keep track of which clients are staying consistent and which
                  ones are falling off.'''
    ,
      id: 6
      uniq_id: 'missed_workouts_tab'
      key: 'InfoTablesView'
      element: (view) -> view.$('.tab-link:nth-child(3)')
      rule: ->
        /\/#welcome/.test(window.location.href) and
        App.request('current_user').get('is_pro')
      title: 'Missed Workouts'
      content: '''See when a client misses a workout and follow-up to
                  re-schedule.'''
    ,

      # CLIENT TOOLTIPS

      id: 0
      uniq_id: 'clients_sidebar_programs1'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'personal_programs'
      main: true
      title: 'Program Overview'
      content: '''With a GymCloud account, you can easily view all the
                  exercises, workouts and programs assigned to you.'''
      docs: '3000049945--web-client-program-overview'
    ,
      id: 1
      uniq_id: 'clients_sidebar_programs2'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'personal_programs'
      title: 'Program Overview'
      content: '''To see the programs assigned to you by your trainer, this is
                  the button you will click.'''
      docs: '3000049945--web-client-program-overview'
    ,
      id: 2
      uniq_id: 'clients_sidebar_workouts'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'personal_workouts'
      title: 'Workout Overview'
      content: '''To view the workouts assigned to you by your trainer, this is
                  the button you will use.'''
      docs: '3000049944--web-client-workout-overview'
    ,
      id: 3
      uniq_id: 'clients_sidebar_exercises'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'workout_exercises'
      title: 'Exercise Overview'
      content: '''You will also have an exercise library, which includes
                  exercises from your workouts and programs.'''
      docs: '3000053218--web-client-exercise-overview'
    ,
      id: 4
      uniq_id: 'clients_sidebar_exercises'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'workout_exercises'
      title: 'Exercise Overview'
      content: '''To check your list of exercises, the is the button you will
                  click.'''
      docs: '3000053218--web-client-exercise-overview'
  ]