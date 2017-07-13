define [
  './template'
], (
  template
) ->

  class View extends Marionette.View

    template: template

    className: 'gc-rating-widget'
