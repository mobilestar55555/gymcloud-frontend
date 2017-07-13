define [
  './styles'
  './template'
  './model'
  '../behavior'
], (
  styles
  template
  Model
  AuthBodyClassBehavior
) ->

  class View extends Marionette.View

    tagName: 'header'

    className: "gc-header-standard gc-header-login #{styles.root}"

    template: template

    templateContext:
      s: styles

    behaviors:

      navigate_back: true

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings:
          'input[type="radio"]': 'plan_id'
          'button[type="submit"]':
            attributes: [
                name: 'disabled',
                observe: 'plan_id',
                onGet: (value) -> !value
            ]
            classes:
              disabled:
                observe: 'plan_id'
                onGet: (value) -> !value

    events:
      'submit form': '_onPlanSelected'

    initialize: ->
      @model = new Model

    _onPlanSelected: ->
      path = ['auth', 'payment_details', @model.get('plan_id')]
      App.vent.trigger('redirect:to', path, replace: false)
