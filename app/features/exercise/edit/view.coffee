define [
  './template'
  'models/video'
], (
  template
  Video
) ->

  class EditOverviewView extends Marionette.View

    key: 'EditOverviewView'

    template: template

    className: 'gc-box-content gc-exercise-wrapper'

    behaviors: ->

      delete_button:
        short: true

      privacy_toggle2:
        enabled: ->
          @view.options.model.type is 'Exercise' and
          App.request('current_user').get('can_manage_privacy')

      video_assigned:
        instantSave: false

      textarea_autosize: true

      stickit:
        bindings:
          '.gc-exercise-name': 'name'
          'textarea': 'description'

    _attrs: ['name', 'description', 'video_id', 'video_url', 'is_public']

    initialize: ->
      @oldAttrs = @model.pick(@_attrs...)
      @listenTo(@, 'childview:video:assign', @videoAssign)
      @message = 'Are you sure you want to leave without saving?'
      @listenToOnce(@model, 'change', @unsavedChanges)

    unsavedChanges: ->
      @isChanged = true
      $(window).on('beforeunload', => @message)
      App.vent.trigger('unsaved:changes')
      $('a').on('click', @clickHandler)

    clickHandler: (ev) =>
      ev.preventDefault()
      path = ev.currentTarget.hash

      App.vent.trigger('redirect:to', path) if confirm(@message)

    removeListeners: ->
      $(window).off('beforeunload')
      App.vent.trigger('no:unsaved:changes')
      $('a').off('click', @clickHandler)

    onBeforeDestroy: ->
      @removeListeners()
      return unless @isChanged
      @model.set(@oldAttrs, silent: true)

    videoAssign: ->
      App.request('modal:video:assign', @model, instantSave: false)
