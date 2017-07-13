# NOTE: not used anymore
define [
  './template'
], (
  template
) ->

  class View extends Marionette.View

    template: template

    className: 'col col-lg-6'

    triggers:
      'click button': 'program_weeks:build'
