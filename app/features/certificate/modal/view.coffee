define [
  './template'
  '../upload/view'
], (
  template
  CertificateUploadView
) ->

  class CertificateUploadModalView extends Marionette.View

    template: template

    className: 'gc-trainer-cert-modal'

    behaviors: ->
      regioned:
        views: [
            region: 'certificate_upload'
            klass: CertificateUploadView
            options: -> @options
        ]
