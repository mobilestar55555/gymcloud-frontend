define [
  './template'
], (
  template
) ->

  class SearchBarView extends Marionette.View

    key: 'SearchBarView'

    template: template

    className: 'gc-topbar-search'

    events:
      'blur @ui.searchTerm': 'searchFocusLost'
      'click @ui.searchButton': 'search'
      'keyup @ui.searchTerm' : 'searchOnEnter'
      'focus @ui.searchTerm': 'activateSearch'

    ui:
      searchTerm: '#gc-topnav-search'
      searchIcon: '.gc-topnav-search-icon'
      searchButton: '.gc-topnav-search-btn'

    onAttach: ->
      user = App.request('current_user')
      @destroy() unless user.get('is_pro')

    searchOnEnter: (ev)->
      if ev.which is 13
        @doSearch @getUI('searchTerm').val()
      else if ev.which is 27
        @cancelSearch()

    doSearch: (q)->
      if q isnt ''
        App.vent.trigger 'search:global', q

    activateSearch: ->
      @getUI('searchIcon').removeClass('glyphicon-search')
      @getUI('searchIcon').addClass('glyphicon-remove')

    cancelSearch: ->
      @getUI('searchTerm').val('')
      unless @getUI('searchTerm').is(':focus')
        @getUI('searchIcon').addClass('glyphicon-search')
        @getUI('searchIcon').removeClass('glyphicon-remove')
      App.vent.trigger 'search:cancel'

    search: (ev) ->
      isSearchInProgress = @getUI('searchButton').find('i')
        .hasClass('glyphicon-remove')
      if isSearchInProgress
        do @cancelSearch
      else
        @doSearch(@getUI('searchTerm').val())

    searchFocusLost: (ev) ->
      ev.preventDefault()
      $sr = $(ev.currentTarget)
      if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
        $sr.addClass('active')
      else
        $sr.removeClass('active')
        @cancelSearch()
