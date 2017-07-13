define [
  './template'
  './root_folders/view'
], (
  template
  RootFolderView
)->

  class SidebarProView extends Marionette.View

    template: template

    events:
      'click @ui.item': 'toggleItem'

    ui:
      subs: '.gc-sidebar-folder > .gc-sidebar-sub, ' +
        '.gc-sidebar-cat > .gc-sidebar-sub'
      catchList: '.gc-assign-catch'
      item: '.gc-sidebar-item > a'
      exercisesRegion: 'region[data-name="exercises"]'
      workoutsRegion: 'region[data-name="workout_templates"]'
      warmupsRegion: 'region[data-name="warmups"]'
      cooldownsRegion: 'region[data-name="cooldowns"]'
      programsRegion: 'region[data-name="program_templates"]'

    regions:
      exercises: '@ui.exercisesRegion'
      workout_templates: '@ui.workoutsRegion'
      warmups: '@ui.warmupsRegion'
      cooldowns: '@ui.cooldownsRegion'
      program_templates: '@ui.programsRegion'

    behaviors: ->

      stickit:
        model: ->
          App.request('current_user').user_settings
        bindings:
          '.clients-title': 'clients_title'

    onRender: ->
      typeByName = (name) ->
        {
          Exercises: 'exercises'
          'Workout Templates': 'workout_templates'
          'Warmup Templates': 'warmups'
          'Cooldown Templates': 'cooldowns'
          'Program Templates': 'program_templates'
        }[name]

      user = App.request('current_user')
      library = user.library

      root = library.models[0]
      root.items.each (folder) =>
        type = typeByName(folder.get('name'))
        # App.request("data:#{type}:reset", folder.items)
        if feature.isEnabled(type)
          view = new RootFolderView
            model: folder
            type: type
          @showChildView(type, view)
        # @initDragAndDrop()

    toggleItem: (ev) ->
      activeItem = @el.querySelector('.gc-sidebar-item > a.active')
      activeItem.classList.remove('active') if activeItem

      ev.currentTarget.classList.add 'active'

    onDomRefresh: ->
      url = document.location.href
      url = url.split('/')[3]
      if url in ['#personal_programs', '#personal_workouts']
        @$el.find('.toggle-menu.last').addClass('active-menu')
      else
        @options.parent.trigger ('loadSidebarItems')