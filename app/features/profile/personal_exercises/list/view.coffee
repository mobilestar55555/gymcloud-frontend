define [
  './item/view'
  'features/profile/personal_assignments/list/empty/view'
], (
  ItemView
  EmptyView
) ->

  class ListView extends Marionette.CollectionView

    childView: ItemView

    className: 'gc-folders-entity-list'

    emptyView: EmptyView

    tagName: 'ul'

    viewComparator: (model) ->
      _.underscore(model.get('name'))

    childViewOptions: ->
      user: @options.user
      type: @collection.type

    initialize: ->
      @request = @collection.fetch()

    onBeforeDestroy: ->
      @request?.abort?()
