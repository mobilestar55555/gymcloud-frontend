define [
  'query-string'

  'views/auth/auth-view'
  'views/auth/forgot-password-view'
  'features/signup/promo_code/view'
  'features/signup/signup_role/view'
  'features/signup/view'
  'views/auth/reset-password-view'
  'views/auth/confirm-registration-view'
  'views/auth/resend-confirmation-view'
  'features/payment/trial_ended/view'
  'features/signup/training_plan_select/view'
  'features/signup/payment_details/view'
  'features/signup/payment_success/view'
  'features/signup/client_assessment/view'
  'features/signup/assessment_report/view'
  'features/signup/confirm_account/view'
  'features/signup/pro_invite/view'
  'features/signup/pro_invite_success/view'
  'features/signup/pro_invite_reminder/view'
  'features/signup/waiting_gymcloud_pro/view'
  'features/signup/find_a_pro/view'
  'features/certificate/blocked_account/view'

  'models/auth/confirm-registration-model'
  'models/auth/resend-confirmation-model'
  'models/auth/reset-password-model'
  'features/signup/model'
  'features/current_user/model'
], (
  QueryString

  AuthView
  ForgotPasswordView
  PromoCodeView
  SignUpRoleView
  SignUpView
  ResetPasswordView
  ConfirmRegistrationView
  ResendConfirmationView
  TrialEndedView
  TrainingPlanSelect
  PaymentsInfoPage
  PaymentSuccessPage
  ClientAssessmentView
  AssessmentReportView
  ConfirmAccountView
  ProInviteView
  ProInviteSuccessView
  ProInviteReminderView
  WaitingGymcloudPro
  FindPro
  CertificateRequiredView

  ConfirmRegistrationModel
  ResendConfirmationModel
  ResetPasswordModel
  AccountModel
  CurrentUser
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'login': 'login'
      'logout':'logout'
      'signup': 'signUp'
      'signup?*queryString': 'signUp'
      'signup-role': 'signupRole'
      'forgot-password': 'forgotPassword'
      'resend_confirmation': 'resendConfirmation'
      'reset/:token': 'resetPassword'
      'confirm/:token': 'confirmRegistration'
      'trial_ended': 'trialEnded'
      'promotion/:code': 'promoCode'

      'auth/training_plan': 'trainingPlanSelect'
      'auth/payment_details/:training_plan': 'paymentDetails'
      'auth/payment_success/:training_plan': 'paymentSuccess'
      'auth/client_assessment(/:key)': 'clientAssessment'
      'auth/assessment_report': 'assessmentReport'
      'auth/confirm_account': 'confirmAccount'

      'auth/pro_invite': 'proInvite'
      'auth/pro_invite_success': 'proInviteSuccess'
      'auth/pro_invite_reminder': 'proInviteReminder'

      'auth/waiting_gymcloud_pro': 'waitingGymcloudPro'
      'auth/find_a_pro': 'findPro'
      'auth/certificate_required': 'certificateUpload'

  class Controller extends Marionette.Controller

    login: (signUp) =>
      if App.request('accessToken:get')
        return App.vent.trigger('redirect:to', '#')

      view = new AuthView
        signUp: signUp
      @_showView(view)

    logout: ->
      App.request('accessToken:remove')
      App.request('data:all:clear')
      App.request('current_user:reset')
      App.vent.trigger('mixpanel:sign_out')
      App.vent.trigger('redirect:to', '#login')

    forgotPassword: ->
      view = new ForgotPasswordView
      @_showView(view)

    promoCode: (code) ->
      view = new PromoCodeView(code: code)
      @_showView(view)

    signupRole: ->
      @_showView(new SignUpRoleView)

    signUp: (queryString) =>
      if App.request('accessToken:get')
        App.vent.trigger('redirect:to', '#')
        return

      queryParams = QueryString.parse(queryString)
      view = new SignUpView
        model: new AccountModel(queryParams)
      @_showView(view)

    resetPassword: (token) =>
      model = new ResetPasswordModel
      view = new ResetPasswordView
        model: model
        token: token
      @_showView(view)

    confirmRegistration: (token) =>
      view = new ConfirmRegistrationView
        token: token
        model: new ConfirmRegistrationModel
        profileModel: new CurrentUser
      @_showView(view)

    resendConfirmation: =>
      model = new ResendConfirmationModel
      view = new ResendConfirmationView
        model: model
      @_showView(view)

    trialEnded: ->
      view = new TrialEndedView
      @_showView(view)

    trainingPlanSelect: ->
      @_showView(new TrainingPlanSelect)

    paymentDetails: (planId) ->
      @_showView(new PaymentsInfoPage(planId: planId))

    paymentSuccess: (planId) ->
      @_showView(new PaymentSuccessPage(planId: planId))

    clientAssessment: (key = 1) ->
      layout = App.request('app:layouts:auth')
      region = layout.getRegion('content')
      view = region?.currentView
      if view instanceof ClientAssessmentView
        view.model.set(view_key: key)
      else
        @_showView(new ClientAssessmentView(view_key: key))

    assessmentReport: ->
      @_showView(new AssessmentReportView)

    confirmAccount: ->
      @_showView(new ConfirmAccountView)

    proInvite: ->
      view = new ProInviteView
      @_showView(view)

    proInviteSuccess: ->
      view = new ProInviteSuccessView
      @_showView(view)

    proInviteReminder: ->
      view = new ProInviteReminderView
      @_showView(view)

    waitingGymcloudPro: ->
      view = new WaitingGymcloudPro
      @_showView(view)

    findPro: ->
      view = new FindPro
      @_showView(view)

    certificateUpload: ->
      view = new CertificateRequiredView
      @_showView(view)

    _showView: (view) ->
      App.request 'views:show', view,
        layout: 'auth'
        region: 'content'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
