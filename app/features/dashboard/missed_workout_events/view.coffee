define [
  './template'
  './item/view'
  '../workout_events/empty/view'
], (
  template
  ItemView
  EmptyView
) ->

  class MissedWorkoutEventsView extends Marionette.CompositeView

    template: template

    className: 'tab-content'

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'tbody'
