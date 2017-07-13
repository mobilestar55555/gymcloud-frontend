define [
  './time_input'
], (
  TimeInputCollectionView
) ->

  class TimeView extends Marionette.View

    template: -> '<div></div>'

    regions: ->
      main:
        el: 'div'
        replaceElement: true

    initialize: ->
      [mins, secs] = (@model.get('value_converted') or [undefined, undefined])
      @collection = new Backbone.Collection [
        {value: mins}
        {value: ':'}
        {value: secs}
      ]

    onAttach: ->
      view = new TimeInputCollectionView
        collection: @collection
      @listenTo(view, 'change:value', (val) -> @model.set(value_converted: val))
      @getRegion('main').show(view)
