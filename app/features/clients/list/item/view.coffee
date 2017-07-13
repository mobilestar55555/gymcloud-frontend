define [
  './template'
  './styles'
], (
  template
  styles
) ->

  class ClientItemView extends Marionette.View

    template: template

    tagName: 'li'

    className: "row #{styles.clients_item}"

    ui:
      deleteSingle: '.gc-clients-list-client-delete'
      moveSingle: '.gc-clients-list-client-move'
      checkbox: 'input[type="checkbox"]'

    events:
      'click @ui.deleteSingle': 'deleteSingle'
      'click @ui.moveSingle': 'moveSingle'

    triggers:
      'change @ui.checkbox': 'checked:single'

    behaviors:
      stickit:
        bindings:
          ".#{styles.avatar}":
            classes:
              "#{styles.individual}": 'user_profile'
              "#{styles.group}": 'avatar'

          ".#{styles.individual}":
            attributes: [
              name: 'style'
              observe: 'user_profile'
              onGet: (value) ->
                url = value.avatar.thumb.url
                color = value.avatar_background_color
                return "background-image: url(#{url})" if url
                "background-color: #{color}" if color
            ]

          ".#{styles.group}":
            attributes: [
              name: 'style'
              observe: 'avatar'
              onGet: (value) ->
                url = value.thumb.url
                "background-image: url(#{url})" if url
            ]

          '.gc-clients-list-client-link':
            observe: 'name'
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (value) ->
                  "##{@options.url}/#{value}"
            ]

    templateContext: ->
      state: @options.state
      s: styles

    deleteSingle: ->
      App.request('modal:confirm:delete', @model)

    moveSingle: ->
      @getUI('checkbox').prop('checked', true)
      @trigger 'move:single'
