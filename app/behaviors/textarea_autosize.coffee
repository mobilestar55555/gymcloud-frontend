define [
  'autosize'
], (
  autosize
)->

  class TextareaAutosize extends Marionette.Behavior

    key: 'textarea_autosize'

    behaviors:
      stickit:
        bindings:
          'textarea':
            afterUpdate: ->
              @_updateAutosizeDelayed()

    initialize: ->
      @_updateAutosizeDelayed = _.debounce(@_updateAutosize, 200)

    onAttach: ->
      @_updateAutosizeDelayed()

    onDomRefresh: ->
      @_updateAutosizeDelayed()

    onBeforeDestroy: ->
      autosize.destroy(@view.$('textarea'))

    _updateAutosize: ->
      autosize(@view.$('textarea'))
