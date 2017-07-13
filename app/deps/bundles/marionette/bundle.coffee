define [
  'deps/bundles/backbone/bundle'
  './original'
  './dirty_hack'
  'deps/behaviors'
  './controller'
], (
  bBackbone
  oMarionette
  DirtyHack
  behaviors
  Controller
) ->

  return window.Marionette if window.Marionette

  oMarionette

  window.Marionette = oMarionette
  oMarionette.Backbone = bBackbone
  bBackbone.Marionette = oMarionette

  if feature.isEnabled('tooltips_tour')

    class OMarionetteView extends oMarionette.View
      constructor: ->
        @listenToOnce @, 'attach', ->
          App.vent.trigger('app:view:show', @)
        @listenToOnce @, 'before:destroy', ->
          App.vent.trigger('app:view:destroy', @)
        super


    oMarionette.View = OMarionetteView

  _.extend(oMarionette.View.prototype, bBackbone.Stickit.ViewMixin)
  DirtyHack(oMarionette)
  Controller(oMarionette)
  oMarionette.Behaviors.behaviorsLookup = behaviors
  oMarionette
