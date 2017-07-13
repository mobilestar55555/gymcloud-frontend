define [
  'features/video/assignment/list/item/view'
  './template'
], (
  AssignVideoItemView
  template
)->
  class VideoLibraryItemView extends AssignVideoItemView

    template: template

    templateContext: ->
      user_id: @options.user_id
