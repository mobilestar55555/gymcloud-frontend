define [
  './template'
], (
  template
) ->

  class View extends Marionette.View

    tagName: 'li'

    className: 'gc-search-filter'

    template: template

    behaviors:
      stickit:
        bindings:
          'a':
            observe: 'name'
            attributes: [
                name: 'href'
                observe: 'href'
            ]

    onRender: ->
      @_markAsActive()

    _markAsActive: ->
      if @model.get('isSelected')
        @el.classList.add('active')
