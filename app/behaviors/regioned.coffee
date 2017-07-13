define ->

  class RegionedBehavior extends Marionette.Behavior

    key: 'regioned'

    defaults:
      views: []

    initialize: ->
      @_bindAll()
      @view.views ?= {}
      super
      @

    onBeforeAttach: ->
      @_initRegions()
      @_initBehaviorViews()

    onAttach: ->
      @_ensureDataIsSynced()
        .done =>
          @_renderBehaviorViews()

    _ensureDataIsSynced: ->
      defer = new $.Deferred
      dfds = {}
      _.each ['model', 'collection'], (namespace) =>
        data = @view[namespace]
        dfds[namespace] = new $.Deferred
        dfd = dfds[namespace]
        if data and data._isRequested and data.url
          @listenToOnce(data, 'sync', ->
            dfd.resolve())
        else
          dfd.resolve()
      $.when(_.values(dfds)...).then(defer.resolve)
      defer.promise()

    _initRegions: ->
      @_doForEachViewOption(@_initRegion)

    _initRegion: (viewOption) =>
      selector = @_getRegionSelector(viewOption.region)
      @view.addRegion viewOption.region,
        el: selector
        replaceElement: !!viewOption.replaceElement

    _getRegionSelector: (regionName) ->
      "region[data-name='#{regionName}']"

    _initBehaviorViews: ->
      @_doForEachViewOption(@_initBehaviorView)

    _initBehaviorView: (viewOption) =>
      viewOption.options ?= -> @options
      viewOption.enabled ?= -> true
      options = _.bind(viewOption.options, @view)()
      @view.views[viewOption.region] = new viewOption.klass(options)

    _renderBehaviorViews: ->
      @_doForEachViewOption(@_renderBehaviorView)

    _renderBehaviorView: (viewOption) =>
      enabled = _.bind(viewOption.enabled, @view)()
      v = @view.views[viewOption.region]
      if enabled
        region = @view.getRegion(viewOption.region)
        region ||= @_initRegion(viewOption)
        region.show(v)

    _doForEachViewOption: (fn) ->
      _.each(@options.views, fn)

    _bindAll: ->
      fns = [
        '_initRegion'
        '_initRegions'
        '_initBehaviorView'
        '_initBehaviorViews'
        '_renderBehaviorView'
        '_renderBehaviorViews'
        '_doForEachViewOption'
      ]
      _.bindAll(@, fns...)
