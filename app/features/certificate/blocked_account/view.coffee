define [
  './template'
  'features/signup/behavior'
  '../upload/view'
], (
  template
  AuthBodyClassBehavior
  CertificateUploadView
) ->

  class CertificateRequiredView extends Marionette.View

    template: template

    behaviors: ->

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      regioned:
        views: [
            region: 'certificate_upload'
            klass: CertificateUploadView
        ]

    events:
      'submit form': '_redirectToLogin'

    onAttach: ->
      @listenToOnce @views.certificate_upload, 'upload', =>
        @$el.find('button[type="submit"]').attr('disabled', true)
      @listenToOnce @views.certificate_upload, 'uploaded', ->
        setTimeout (-> window.location.reload()), 100
        App.vent.trigger('redirect:to', ['welcome'])

    _redirectToLogin: ->
      App.request('accessToken:remove')
      App.vent.trigger('redirect:to', ['login'])
