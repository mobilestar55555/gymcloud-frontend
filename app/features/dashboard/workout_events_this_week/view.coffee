define [
  './item/view'
  './collection'
  './empty/view'
], (
  ItemView
  DaysCollection
  EmptyView
) ->

  class WorkoutEventsThisWeekView extends Marionette.CollectionView

    className: 'tab-content'

    emptyView: EmptyView

    childView: ItemView

    childViewOptions: (model) ->
      collection: model.workout_events

    viewComparator: (day) ->
      day.id * -1

    initialize: ->
      @collection = new DaysCollection
      @listenTo @options.events, 'add', (event) ->
        date = event.get('begins_at')
        id = moment(date).startOf('day').valueOf()
        day = @collection.get(id) or @collection.add(id: id, date: date)
        day.workout_events.add(event)
