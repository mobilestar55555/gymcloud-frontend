define [
  './template'
  './model'
  'features/dashboard/client_performance/view'
], (
  template
  DataModel
  ClientPerformanceCollectionView
) ->

  class InfoTablesView extends Marionette.View

    key: 'InfoTablesView'

    template: template

    behaviors: ->
      getBindingFor = (name) ->
        ".content > [data-name='#{name}']":
          observe: 'tab'
          visible: (value) ->
            value is name
        "[tab-name='#{name}']":
          classes:
            active:
              observe: 'tab'
              onGet: (value) ->
                value is name

      stickit:
        bindings: _.reduce(@options.tables, (obj, table) ->
          _.extend(obj, getBindingFor(table.region))
        , {})

      regioned:
        views: @options.tables

    events:
      'click .tab-link': '_onChangeTab'

    templateContext: ->
      tables: @options.tables

    initialize: ->
      @model = new DataModel
        tab: @options.tables[0].region

    _onChangeTab: (ev) ->
      tabName = $(ev.currentTarget).attr('tab-name')
      @model.set(tab: tabName)

    onDomRefresh: ->
      @$el.find('[data-toggle="tooltip"]').tooltip('destroy')
      @$el.find('[data-toggle="tooltip"]').tooltip(html: true)

    onDestroy: ->
      @$el.find('[data-toggle="tooltip"]').tooltip('destroy')
