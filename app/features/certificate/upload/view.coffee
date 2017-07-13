define [
  './template'
  './model'
], (
  template
  Model
) ->

  class CertificateUploadView extends Marionette.View

    template: template

    className: 'gc-trainer-cert-modal'

    ui:
      uploadControl: 'input'
      uploadDropzone: '.cert-upload-area'

    behaviors: ->

      stickit:
        bindings:
          ':el':
            classes:
              'in-upload':
                observe: 'state'
                onGet: (value) ->
                  value is 'in-upload'
              'success-upload':
                observe: 'state'
                onGet: (value) ->
                  value is 'success-upload'
          'h3': 'header'
          '.description': 'description'
          '.certificate-file-name': 'name'
          '.progress-status span':
            attributes: [
                name: 'data-progress'
                observe: 'progress'
                onGet: (value) ->
                  "#{value}%"
              ,
                name: 'style'
                observe: 'progress'
                onGet: (value) ->
                  "width:#{value}%"
            ]
          'input':
            attributes: [
                name: 'disabled'
                observe: 'state'
                onGet: (value) ->
                  value is 'in-upload'
            ]

    initialize: ->
      @model = new Model
        type: @options.type

    onAttach: ->
      @getUI('uploadControl').fileupload
        url: '/certificates'
        dropZone: @ui.uploadDropzone
        dataType: 'json'
        add: @_onFileAdd
        done: @_fileUploaded
        progressall: @_updateProgress

    _updateProgress: (e, data) =>
      progress = parseInt(data.loaded / data.total * 100, 10)
      @model.set(progress: progress)

    _fileUploaded: =>
      user = App.request('current_user')
      user.set(has_certificate: true)
      @model.set(state: 'success-upload')
      @trigger('uploaded')
      App.request('messenger:explain', 'user.certificate.uploaded')

    _onFileAdd: (_e, data) =>
      @model.set
        name: data.files[0].name
        state: 'in-upload'
      data.submit()
      @trigger('upload')
