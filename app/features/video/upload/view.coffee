define [
  './template'
], (
  template
) ->

  class UploadVideoModal extends Marionette.View

    template: template

    ui:
      'uploadTrigger': '.gc-upload-trigger'
      'uploadControl': '.gc-video-upload-control'
      'uploadDetailsPanel': '.gc-video-item-upload'
      'videoFileName': '.gc-video-file-name'
      'uploadProgress': '.gc-progress'
      'uploadProgressText': '.gc-progress-text'
      'footerButton': '.gc-footer-btn'
      'uploadDropzone': '.gc-video-upload'
      'deleteVideo': '.gc-delete-video'
      'editName': '.gc-update-name'
      'uploadControls': '.gc-video-controls'

    events:
      'click @ui.uploadTrigger': 'upload'
      'click @ui.deleteVideo': 'deleteVideo'
      'click @ui.editName': 'toggleEditName'
      'blur @ui.videoFileName': 'saveVideoDetails'
      'click .gc-cancel-video-upload': 'cancelVideoUpload'
      'click .close': 'cancelVideoUpload'

    behaviors:
      stickit:
        bindings:
          '.gc-video-file-name': 'name'

    extensionsRegex: /\.(webm|mkv|flv|vob|mp4|m4v|avi|mpeg|mpg|3gp|mov)$/i

    initialize: ->
      @file = {}

    onAttach: ->
      @_initFileUpload()

    _initFileUpload: ->
      @getUI('uploadControl').fileupload
        url: '/videos'
        dropZone: @ui.uploadDropzone
        dataType: 'json'
        add: @_onFileAdd
        done: @_videoUploaded
        progressall: @_showProgress

      .bind 'fileuploadsubmit', (e, data) =>
        data.formData = name: @file.name

    upload: ->
      @getUI('uploadControl').click()

    processFile: (info) ->
      @model.set 'name', info.name
      @getUI('uploadDetailsPanel').removeClass 'hidden'

    _showProgress: (e, data) =>
      progress = parseInt(data.loaded / data.total * 100, 10)
      @_updateProgress progress

    _videoUploaded: (e, data) =>
      @model.set(data.result)
      @getUI('footerButton').text('Finish')
      @getUI('uploadControls').removeClass('hidden')
      @getUI('videoFileName').attr('contenteditable', true)
      App.vent.trigger('mixpanel:track', 'video_uploaded', @model)
      @trigger('videoUploaded', @model)
      App.request('messenger:explain', 'video.uploaded')
      @jqXHR = null

    _updateProgress: (value) =>
      @getUI('uploadProgress').css('width', "#{value}%")
      @getUI('uploadProgressText').text("#{value}%")

    _onFileAdd: (_e, data) =>
      @file = data.files[0]
      if !@extensionsRegex.test(@file.name)
        App.request('messenger:explain', 'video.invalid_type')
        return

      @processFile @file
      @jqXHR = data.submit()
      @getUI('videoFileName').attr 'contenteditable', false

    deleteVideo: ->
      @model.destroy().then =>
        @model.clear()
        @getUI('uploadDetailsPanel').addClass('hidden')
        @getUI('uploadControls').addClass('hidden')
        @_updateProgress(0)
        App.request('messenger:explain', 'video.deleted')

    toggleEditName: ->
      @getUI('videoFileName').focus()

    saveVideoDetails: (ev) ->
      return ev unless @model.hasChanged('name')

      @model.save().then ->
        App.request('messenger:explain', 'video.updated')

    cancelVideoUpload: (ev) ->
      return @trigger('modal:closed') unless @jqXHR

      question = 'Are you sure you want to stop this video upload?'
      if window.confirm(question)
        @jqXHR && @jqXHR.abort?()
        @trigger('modal:closed')
