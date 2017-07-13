define ->

  class BaseRegionedBehavior extends Marionette.Behavior

    key: -> @regionName

    # NOTE: name of a region where to show the view
    regionName: undefined

    # NOTE: view constructor function
    behaviorViewClass: undefined

    # NOTE: view options to pass
    behaviorViewOptions: {}

    enabled: ->
      @_featureIsEnabled()

    defaults: {}

    initialize: ->
      super
      @isEnabled = if _.has(@options, 'enabled')
        _.bind(@options.enabled, @)()
      else
        _.result(@, 'enabled')
      _.bindAll @, [
        '_initBehaviorView'
        '_renderBehaviorView'
      ]...
      if @isEnabled
        @listenTo(@view, 'before:attach', @_initRegion)
        @listenTo(@view, 'before:attach', @_initBehaviorView)
        @listenTo(@view, 'attach', @_renderBehaviorView)
      @

    _initRegion: ->
      @view.addRegion @regionName,
        el: @_getRegionSelector()
        replaceElement: !!@options.replaceElement

    _getRegionSelector: ->
      "region[data-name='#{@regionName}']"

    _initBehaviorView: ->
      options = _.result(@, 'behaviorViewOptions')
      @behaviorView = new @behaviorViewClass(options)

    _renderBehaviorView: ->
      region = @view.getRegion(@regionName)
      region.show(@behaviorView, replaceElement: !!@options.replaceElement)
      # @view.showChildView(@regionName, @behaviorView)

    _featureIsEnabled: ->
      key = _.result(@, 'key')
      return true unless feature.includes(key)
      feature.isEnabled(key)
