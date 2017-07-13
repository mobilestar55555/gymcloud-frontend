define [
  './template'
  './personal/view'
  './pro/view'
], (
  template
  PersonalCollectionView
  SidebarProView
)->

  class SidebarView extends Marionette.View

    template: template

    className: 'gc-sidebar'

    ui:
      item: '.gc-sidebar-item > a'

    events:
      'click .toggle-menu': 'toggleMenu'
      'click @ui.item': 'toggleItem'
      'click .nano': 'onClickSidebar'

    behaviors:

      regioned:
        views: [
            region: 'pro'
            klass: SidebarProView
            options: -> {parent: @}
            enabled: ->
              @user.get('is_pro')
          ,
            region: 'workout_exercises'
            klass: PersonalCollectionView
            options: ->
              collection: @user.workout_exercises
              type: 'workout_exercises'
              title: 'Exercises'
              parent: @
            enabled: ->
              feature.isEnabled('workout_exercises') and
              not @user.get('is_pro')
          ,
            region: 'personal_workouts'
            klass: PersonalCollectionView
            options: ->
              collection: @user.personal_workouts
              type: 'personal_workouts'
              title: 'Workouts'
              parent: @
            enabled: ->
              feature.isEnabled('personal_workouts') and
              not @user.get('is_pro')
          ,
            region: 'personal_programs'
            klass: PersonalCollectionView
            options: ->
              collection: @user.personal_programs
              type: 'personal_programs'
              title: 'Programs'
              parent: @
            enabled: ->
              feature.isEnabled('personal_programs') and
              not @user.get('is_pro')
          ,
            region: 'personal_warmups'
            klass: PersonalCollectionView
            options: ->
              collection: @user.personal_warmups
              type: 'personal_warmups'
              title: 'Warmups'
              parent: @
            enabled: ->
              feature.isEnabled('personal_warmups') and
              not @user.get('is_pro')
          ,
            region: 'personal_cooldowns'
            klass: PersonalCollectionView
            options: ->
              collection: @user.personal_cooldowns
              type: 'personal_cooldowns'
              title: 'Cooldowns'
              parent: @
            enabled: ->
              feature.isEnabled('personal_cooldowns') and
              not @user.get('is_pro')
        ]

    initialize: ->
      @user = App.request('current_user')
      @listenTo @, 'loadSidebarItems', @_loadActiveItem

    toggleMenu: (ev) ->
      target = $(ev.target)
      currentTarget = $(ev.currentTarget)
      $('.gc-sidebar-wrapper').niceScroll
        scrollspeed: '1'
        cursorwidth: '3px'
        railpadding: {top: 0, right: 1.5, left: 0, bottom: 0}
        cursorborder: false
        cursorborderradius: 0
        cursorcolor: '#fff'

      # if target is caret prevent navigation
      # only cascade sub-items
      if target.hasClass('toggle-it')
        ev.preventDefault()
        currentTarget.toggleClass('active')
      else # redirect and set as active item
        # remove active ewp item if any #3a99d8
        @_setActiveRootMenuItem(currentTarget)
        @_removeActiveItem()

    toggleItem: (ev) ->
      @_removeActiveItem()
      ev.currentTarget.classList.add 'active'

    _removeActiveItem: ->
      activeItem = @$el.find('.gc-sidebar-item > a.active')
      activeItem.removeClass('active') if activeItem

    # Note: An Active Menu is the one that is currently being
    # viewed by the user. (list or item that is dispalyed in the content region)
    _setActiveRootMenuItem: (target) ->
      currentActiveMenu = @$el.find('a.active-menu')
      currentActiveMenu.removeClass('active-menu') if currentActiveMenu

      target.addClass('active-menu')

    _loadActiveItem: ->
      url = document.location.href
      url = url.split('/')[3]
      $.each @$el.find('.gc-sidebar-cat > .toggle-menu'), ->
        if @href.indexOf(url) > -1
          $(@).addClass 'active-menu'