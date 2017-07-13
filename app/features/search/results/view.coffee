define [
  './template'
  './groups/view'
  './public_scopes/collection'
  './public_scopes/view'
  './filters/collection'
  './filters/view'
  './groups/empty/view'
], (
  template
  GroupsView
  SearchScopes
  SearchScopesView
  SearchFilters
  SearchFiltersView
  EmptyView
) ->

  class View extends Marionette.View

    className: 'gc-search-results-main'

    template: template

    regions:
      publicScopes: 'region[data-name="public-scopes"]'
      resultGroups: 'region[data-name="search-results"]'
      searchFilters: 'region[data-name="search-filters"]'

    initialize: ->
      @_initCollections()


    onAttach: ->
      @listenTo @collection, 'sync', ->
        items = @collection.any((model) ->
          model.get('items').length > 0
        )
        if items
          view = new GroupsView
            collection: @collection
        else
          view = new EmptyView
            type: @model.get('entity_type')
        @getRegion('resultGroups').show(view)

      view = new SearchScopesView
        collection: @searchScopes
        model: @model
      # @showChildView('publicScopes', view)

      view = new SearchFiltersView
        collection: @searchFilters
      @showChildView('searchFilters', view)

    _initCollections: ->

      q = @model.get('q')
      entityType = @model.get('entity_type')
      searchScope = @model.get('search_scope')

      @searchScopes = new SearchScopes [
          name: 'gymcloud'
          value: 'public'
          inScope: searchScope == 'public'
      ]

      @searchFilters = new SearchFilters [
          name: 'All'
          isSelected: entityType == 'all'
          href: "#search/#{q}"
        ,
          name: 'Exercises'
          isSelected: entityType == 'exercises'
          href: "#search/#{q}/exercises"
        ,
          name: 'Workouts'
          isSelected: entityType == 'workouts'
          href: "#search/#{q}/workouts"
        ,
          name: 'Programs'
          isSelected: entityType == 'programs'
          href: "#search/#{q}/programs"
        ,
          name: 'Clients'
          isSelected: entityType == 'clients'
          href: "#search/#{q}/clients"
        ,
          name: 'Groups'
          isSelected: entityType == 'client_groups'
          href: "#search/#{q}/client_groups"
      ]
