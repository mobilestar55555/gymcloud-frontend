define [
  './no_videos_uploaded.jade'
], (
  template
) ->

  class NoVideosUploadedView extends Marionette.View

    template: template

    className: 'gc-empty-view-content'
