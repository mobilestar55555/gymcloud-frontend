define ->

  observerSettings =
    childList: true
    subtree: true
    attributes: true

  emptyImg = 'data:image/gif;base64,R0lGODlhAQABAAAAACwAAAAAAQABAAA='

  class ImageErrorReplacer

    constructor: (@app) ->
      _.bindAll @, [
        '_initObserver'
        '_processMutations'
        '_processMutation'
        '_isImageMutation'
      ]...
      @app.on('start', @_initObserver)

    _initObserver: ->
      observer = new MutationObserver(@_processMutations)
      observer.observe(document.documentElement, observerSettings)

    _processMutations: (mutations) ->
      mutations.forEach(@_processMutation)

    _processMutation: (mutation) ->
      return unless @_isImageMutation(mutation)
      mutation.target.onerror = ->
        @src = emptyImg

    _isImageMutation: (mutation) ->
      mutation.type is 'attributes' and
      mutation.attributeName is 'src' and
      mutation.target.tagName is 'IMG' and
      mutation.target.src isnt emptyImg
