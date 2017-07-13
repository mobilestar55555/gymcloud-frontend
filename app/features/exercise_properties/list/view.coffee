define [
  './item/readable/view'
  './item/editable/view'
  './empty/view'
], (
  ItemReadableView
  ItemEditableView
  EmptyView
) ->

  class ExercisePropertiesListView extends Marionette.CollectionView

    tagName: 'ul'

    className: 'workout-exercise-properties draggable-container'

    emptyView: EmptyView

    childView: (model) =>
      if @editableStateId is model.cid
        ItemEditableView
      else
        ItemReadableView

    childViewEvents:
      'switchTo:editable': '_switchToEditable'
      'switchTo:readable': '_switchToReadable'
      'edited': '_edited'

    initialize: ->
      @editableStateId = null
      @default_property = App.request('data:personal_properties:visible')
        .findWhere(name: 'Sets').attributes
      @listenTo(@, 'properties:init', @initProperty)
      @listenTo(@, 'properties:add', @addProperties)
      @listenTo(App.vent, 'drag_n_drop:item:dropped', @_handleDropped)

    initProperty: (options = {}) ->
      model = @collection.initProperty(
        options.workout_exercise_id,
        @default_property
      )
      childView = @children.findByModel(model)
      @_switchViewStateFor(childView, 'editable')

    addProperties: (options = {}) ->
      @collection.addProperties(
        options.exercise_properties,
        options.workout_exercise_id
      ).then =>
        @trigger('edited')

    _switchToEditable: (childView) ->
      @_switchViewStateFor(childView, 'editable')

    _switchToReadable: (childView) ->
      @_switchViewStateFor(childView, 'readable')

    _switchViewStateFor: (childView, state = 'readable') ->
      if state is 'readable'
        @editableStateId = null
      else
        @editableStateId = childView.model.cid
      @collection.remove(childView.model)
      @collection.add(childView.model, at: childView._index)

    _handleDropped: (el, target, source, sibling) ->
      @_updatePosition() if target is @el

    _updatePosition: ->
      @children.each (view) ->
        view.model.set
          position: view.$el.index()
        view.model.patch()
      @collection.sort()

    _edited: ->
      @trigger('edited')