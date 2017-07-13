define [
  './item/view'
  './empty/view'
  './template'
], (
  ItemView
  EmptyView
  template
) ->

  class WorkoutEventsTableView extends Marionette.CompositeView

    className: 'tab-content'

    template: template

    templateContext: ->
      withStatus: @options.withStatus

    childView: ItemView

    childViewContainer: 'tbody'

    childViewOptions: ->
      withStatus: @options.withStatus

    emptyView: EmptyView

    ui:
      thead: 'thead'

    initialize: ->
      @listenTo(@collection, 'sync', @_onCollectionSizeChange)

    onAttach: ->
      @_onCollectionSizeChange()

    _onCollectionSizeChange: ->
      if @collection.isEmpty()
        @getUI('thead').hide()
      else
        @getUI('thead').show()
