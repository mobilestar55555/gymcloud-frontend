define [
  './model'
  './styles'
  './template'
  '../behavior'
], (
  Model
  styles
  template
  AuthBodyClassBehavior
) ->

  class PromoCodeView extends Marionette.View

    tagName: 'header'

    className: "gc-header-standard gc-header-login #{styles.promo}"

    template: template

    templateContext:
      s: styles

    behaviors:

      navigate_back: true

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    initialize: ->
      @model = new Model(@options)
      @model.fetch()
        .then(@_codeFound)
        .fail(@_codeNotFound)

    _codeFound: (data) ->
      window.localStorage.setItem('promo_code', data.code)
      App.vent.trigger('redirect:to', '#signup?is_pro=false')

    _codeNotFound: ->
      App.request('messenger:explain', 'error.not_found')
      App.vent.trigger('redirect:to', '#login')
