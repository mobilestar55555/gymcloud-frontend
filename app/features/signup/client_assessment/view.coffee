define [
  './styles'
  './template'
  '../behavior'
  './progress_model'
  './model'
  './q1/view'
  './q2/view'
  './q3/view'
  './q4/view'
  './q5/view'
  './q6_1/view'
  './q6_2/view'
  './q6_3/view'
  './q7_1/view'
  './q7_2/view'
  './q7_3/view'
  './q8/view'
  './q9/view'
], (
  styles
  template
  AuthBodyClassBehavior
  ProgressModel
  AssessmentReportModel
  Question1View
  Question2View
  Question3View
  Question4View
  Question5View
  Question6_1View
  Question6_2View
  Question6_3View
  Question7_1View
  Question7_2View
  Question7_3View
  Question8View
  Question9View
) ->

  class ClientAssessmentView extends Marionette.View

    tagName: 'header'

    className: "gc-header-standard gc-header-login #{styles.client_assessment}"

    template: template

    templateContext:
      s: styles

    behaviors:

      navigate_back: true

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings:
          ".#{styles.assessment_progress} .description": 'progress_description'
          ".#{styles.assessment_progress} progress":
            attributes: [
                name: 'max',
                observe: 'view_count'
              ,
                name: 'value'
                observe: 'view_id'
            ]
          ".#{styles.next}":
            observe: ['view_count', 'view_id']
            onGet: ([count, id]) ->
              if count is id then 'Finish' else 'Next'
            classes:
              disabled:
                observe: 'is_valid'
                onGet: (bool) -> !bool

    questionViews:
      '1': Question1View
      '2': Question2View
      '3': Question3View
      '4': Question4View
      '5': Question5View
      '6_1': Question6_1View
      '6_2': Question6_2View
      '6_3': Question6_3View
      '7_1': Question7_1View
      '7_2': Question7_2View
      '7_3': Question7_3View
      '8': Question8View
      '9': Question9View

    regions:
      assessmentStep: 'region[data-name="assessment_step"]'

    events:
      "click .#{styles.next}:not(.disabled)": '_onNext'

    initialize: ->
      @report = @_getAssessmentReportModel()
      @model = new ProgressModel(view_key: @options.view_key)
      @listenTo(@model, 'change:view_key', @_renderQuestionView)

    onAttach: ->
      @_renderQuestionView()

    _getAssessmentReportModel: ->
      user = App.request('current_user')
      user.assessment_report ||= new AssessmentReportModel

    _renderQuestionView: ->
      view = @_prepareView()
      return if view is undefined
      view.listenTo(view, 'change:progress', _.bind(@_onProgressAttrsChange, @))
      region = @getRegion('assessmentStep')
      region.show(view)

    _prepareView: ->
      index = @model.get('view_key')
      ViewKlass = @questionViews[index]
      return new ViewKlass(model: @report) if ViewKlass

      @_finishClientAssessment()
      undefined

    _onNext: ->
      $('body, html').stop().animate({scrollTop:0}, '500')
      region = @getRegion('assessmentStep')
      oldView = region.currentView
      newIndex = oldView.getNextViewKey()
      @model.set(view_key: newIndex)
      path = ['auth', 'client_assessment', newIndex]
      App.vent.trigger('redirect:to', path, replace: false, trigger: false)

    _onProgressAttrsChange: (attributes) ->
      @model.set(attributes)

    _finishClientAssessment: ->
      path = ['auth', 'assessment_report']
      App.vent.trigger('redirect:to', path, replace: false)
