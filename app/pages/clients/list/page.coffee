define [
  'pages/base/page'
  './template'
  'features/clients/list/view'
  'features/clients/list/add_individual_modal/view'
  'features/clients/list/add_group_modal/view'
  'models/client'
  'models/client_group'
], (
  BasePage
  template
  ClientsListView
  AddIndividualModal
  AddGroupModal
  Individual
  Group
) ->

  class Page extends BasePage

    behaviors: ->

      navigation_content_tabs:
        data: [
            id: 'individuals'
            title: 'Individuals'
          ,
            id: 'groups'
            title: 'Groups'
        ]

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initViews: ->
      user = App.request('current_user')
      individuals: ->
        new ClientsListView
          collection: user.clients
          state: @model.get('state.subpage')
          path: 'users'
          clientType: _.singularize(user.user_settings.get('clients_title'))
          modalViewClass: AddIndividualModal
          modalModelClass: Individual
      groups: ->
        new ClientsListView
          collection: user.client_groups
          state: @model.get('state.subpage')
          path: 'client_groups'
          clientType: 'group'
          modalViewClass: AddGroupModal
          modalModelClass: Group
