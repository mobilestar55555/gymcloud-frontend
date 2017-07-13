define [
  './no_results.jade'
], (
  template
) ->

  class NoResultsView extends Marionette.View

    template: template

    className: 'gc-empty-view-content'
