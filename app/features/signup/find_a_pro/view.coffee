define [
  './template'
  '../pro_invite/model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class FindProView extends Marionette.View

    template: template

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    initialize: ->
      model = new Model
      model.request()
