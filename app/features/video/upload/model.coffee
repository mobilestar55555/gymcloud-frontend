define [
  'backbone'
], (
  Backbone
) ->

  class Video extends Backbone.Model

    urlRoot: '/videos'

    defaults:
      duration: undefined
      embed_url: undefined
      id: undefined
      name: undefined
      preview_picture_url: undefined
      status: undefined
      uploaded_at: undefined
      vimeo_id: undefined
      vimeo_url: undefined

    initialize: ->
      @listenToOnce(@, 'change:vimeo_url', @_checkAvailability)

    _checkAvailability: ->
      return unless @id
      return @trigger('available') if @get('status') is 'available'
      @_checkIfUploaded()

    _checkIfUploaded: ->
      # setTimeout(_.bind(@_fetchVideo, @), 5000)

      # action_cable implementation
      key = "video_#{@id}"
      that = @
      fn = (data) ->
        that.set(data) if data?.id is that.id

      App.request('cable:register', key, 'VimeoUploadChannel', received: fn)
      App.request('cable:subscribe', key)

      @listenTo @, 'available destroy garbage', ->
        App.request('cable:unsubscribe', key)
        App.request('cable:unregister', key)

    _fetchVideo: ->
      @fetch().then(_.bind(@_checkAvailability, @))
