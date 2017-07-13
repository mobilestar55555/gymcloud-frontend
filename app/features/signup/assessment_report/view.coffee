define [
  './styles'
  './template'
  '../behavior'
], (
  styles
  template
  AuthBodyClassBehavior
) ->

  class AssessmentReportView extends Marionette.View

    tagName: 'header'

    className: "gc-header-standard gc-header-login #{styles.assessment_report}"

    template: template

    templateContext:
      s: styles

    behaviors:

      navigate_back: true

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    events:
      'click .btn': '_redirectToDashboard'

    _redirectToDashboard: ->
      token = App.request('accessToken:get')
      App.request('auth:onSuccess', access_token: token)
        .then ->
          user = App.request('current_user')
          assessmentReport = user.assessment_report
          id = assessmentReport.get('movement_assessment_id')
          setTimeout ->
            App.vent.trigger('redirect:to', ['personal_workouts', id])
          , 250
