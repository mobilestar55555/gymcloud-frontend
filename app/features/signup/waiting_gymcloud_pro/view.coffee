define [
  './template'
  '../behavior'
], (
  template
  AuthBodyClassBehavior
) ->

  class WaitingGymcloudProView extends Marionette.View

    template: template

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior
