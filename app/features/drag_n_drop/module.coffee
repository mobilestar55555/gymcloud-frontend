define [
  'dragula'
], (
  Dragula
) ->

  class Module

    constructor: (@app) ->
      @_initInstance()

    _initInstance: ->
      options =
        isContainer: (el) ->
          el.classList.contains('draggable-container')
        moves: (el, source, handle, sibling) ->
          handle.classList.contains('draggable-handle')
        accepts: (el, target, source, sibling) ->
          $el = $(el)
          $target = $(target)
          rules =
            [
              [
                'gc-program-workout-item'
                'gc-program-workouts-list'
              ]
              [
                'gc-workout-exercise-item'
                'gc-workout-exercises-list'
              ]
              [
                'gc-properties-list-item'
                'gc-properties-list'
              ]
              [
                'gc-property-item'
                'workout-exercise-properties'
              ]
            ]
          _.any rules, (classNames) ->
            # Following condition could be added into 'rules' array
            return target is source if $el.hasClass('gc-property-item')
            $el.hasClass(classNames[0]) and $target.hasClass(classNames[1])

      @smaug = Dragula [], options

      @smaug.on 'drop', (el, target, source, sibling) ->
        App.vent.trigger('drag_n_drop:item:dropped', arguments...)

      @smaug.on 'drag', (el, source) =>
        sourceChild = '>.gc-program-workout-item'
        if $(source).find(sourceChild).length > 0
          document.addEventListener('mousemove', @_onMouseMove)

      @smaug.on 'dragend', (el) =>
        document.removeEventListener('mousemove', @_onMouseMove)

    _onMouseMove: (e) =>
      @_pageY = e.pageY
      if @smaug.dragging
        delta = 120
        y = @_pageY
        container = $('.gc-workspace-content')[0]
        containerTop = container.offsetTop
        containerBottom = containerTop + container.offsetHeight
        if containerBottom - y < delta
          @_scrollDown(container, y)
        else if (containerTop + y) < (delta + 200)
          @_scrollUp(container, y)
      return

    _scrollDown: (container, pageY) ->
      if @smaug.dragging and pageY == @_pageY
        container.scrollTop += 18
        setTimeout @_scrollDown.bind(@, container, pageY), 30

    _scrollUp: (container, pageY) ->
      if @smaug.dragging and pageY == @_pageY
        container.scrollTop -= 25
        setTimeout @_scrollUp.bind(@, container, pageY), 30
