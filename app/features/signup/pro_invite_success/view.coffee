define [
  './template'
  '../pro_invite/model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class ProInviteSuccessView extends Marionette.View

    template: template

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior