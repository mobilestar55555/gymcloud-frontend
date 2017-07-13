define ->

  class CertificateUploadModel extends Backbone.Model

    defaults:
      name: ''
      header: ''
      description: ''
      state: ''
      progress: 0

    initialize: (attrs) ->
      options = if attrs.type is 'add_client'
        description: '''Please upload a photo of your professional certification
        before adding clients to your GymCloud account'''
        header: 'Adding Clients'
      else
        description: '''Please upload a photo of your professional certification
        to continue using GymCloud'''
        header: 'Upload Certification'
      @set(options)
