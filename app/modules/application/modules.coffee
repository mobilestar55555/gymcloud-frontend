define [
  'routers/all'
  'features/current_user/module'
  'features/header/module'
  'features/spinner/module'
  'features/messenger/module'
  'features/sidebar/module'
  'features/search/module'
  'features/modal/confirm/module'
  'features/modal/prompt/module'
  'features/modal/client_groups/module'
  'features/modal/assign_video/module'
  'features/drag_n_drop/module'
  'features/tutorial/module'
  'modules/utils/freshdesk'
  'modules/utils/google_analytics'
  'features/certificate/modal/module'
  'features/payment/cancel_subscription/module'
  'features/action_cable/module'
  'modules/utils/image_error_replacer'
], (
  AllRouters
  CurrentUserModule
  HeaderModule
  SpinnerModule
  MessengerModule
  SidebarModule
  SearchModule
  ModalConfirmModule
  ModalPromptModule
  ModalClientGroupModule
  ModalAssignVideo
  DragNDropModule
  TutorialModule
  FreshDeskModule
  GoogleAnalyticsModule
  CertificateUploadModule
  CancelSubscriptionModule
  ActionCable
  ImageErrorReplacer
) ->

  (app) ->

    new AllRouters(app)
    new CurrentUserModule(app)
    new HeaderModule(app)
    new SidebarModule(app)
    new SpinnerModule(app)
    new MessengerModule(app)
    new SearchModule(app) if feature.isEnabled('search_global')
    new ModalConfirmModule(app)
    new ModalPromptModule(app)
    new ModalClientGroupModule(app)
    new ModalAssignVideo(app)
    new DragNDropModule(app)
    new TutorialModule(app)
    new CertificateUploadModule(app)
    new CancelSubscriptionModule(app)
    new FreshDeskModule(app) if feature.isEnabled('freshdesk_widget')
    new GoogleAnalyticsModule(app) if feature.isEnabled('google_analytics')
    new ActionCable(app)
    new ImageErrorReplacer(app)
