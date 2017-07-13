define [
  'pages/base/page'
  './template'
  'models/exercise'
  './overview/view'
], (
  BasePage
  template
  Exercise
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new Exercise(id: @options.id)

    originalModel: ->
      user = App.request('current_user')
      user.exercises?.get(@options.id)

    originalAttrsToListen: ->
      ['name', 'updated_at', 'folder_id', 'is_public']

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
          user: @options.user
