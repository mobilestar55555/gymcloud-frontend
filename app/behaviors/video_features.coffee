define ->

  class VideoFeatures extends Marionette.Behavior

    key: 'video_features'

    ui:
      player: '.gc-video-preview'
      play: '.gc-video-play'

    events:
      'click @ui.play': 'renderIframe'

    initialize: ->
      @model = @view.options.model
      @listenTo(@view, 'destroyIframe', @destroyIframe)

    renderIframe: (ev) ->
      @view.trigger('playVideo')
      iframe = document.createElement('iframe')
      iframe.setAttribute('src', "#{@model.get('embed_url')}?autoplay=1")
      iframe.setAttribute('allowfullscreen', 'allowfullscreen')
      iframe.setAttribute('frameborder', '0')
      @getUI('player').append(iframe)
      $(ev.currentTarget).hide()

    destroyIframe: ->
      @getUI('player').find('iframe').remove()
      @getUI('player').find('i').show()
