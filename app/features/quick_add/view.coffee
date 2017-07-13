define [
  './template'
  './model'
], (
  template
  Model
) ->

  class QuickAddView extends Marionette.View

    key: 'QuickAddView'

    template: template

    ui:
      'button': 'button'
      'inputWrapper': '.gc-exercises-assign-input-wrapper'

    events: ->
      'click @ui.button': =>
        @model.set('state', 'autocomplete')
        @$el.find('.selectize-input input').focus()
      'blur @ui.inputWrapper': =>
        @model.set('state', 'button')

    templateContext: ->
      isIconHidden: =>
        !!@options.isIconHidden

    behaviors: ->

      stickit:
        bindings: ->
          'button':
            observe: 'state'
            visible: (value) ->
              value is 'button'
          'button span span':
            observe: 'modelName'
            onGet: (value) =>
              @options.buttonName || "Add #{value}"
          '.gc-exercises-assign-input-wrapper':
            observe: 'state'
            visible: (value) ->
              value is 'autocomplete'
          '.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'modelName'
                onGet: (value) ->
                  name = _.chain(value)
                    .humanize()
                    .pluralize()
                    .value()
                  "Search #{name}"
            ]
      auto_complete:
        onItemAdd: (value, $item, selectize) ->
          selectize.clear()
          selectize.close()
          @trigger('quick_add:chosen', value, $item)
        collection: ((view) ->
          result = view.options.collection
            .map (item) ->
              folder: false
              id: item.get('id')
              name: item.get('name')
              sort_id: "~-2-#{_.underscore(item.get('name'))}"
          type = _.humanize(view.options.collection.model.prototype.type)
          result.unshift
            id: 0
            name: view.options.newButtonName || "CREATE NEW #{type}"
            icon: 'gc-icon-exercises-add'
            sort_id: '~-1-sort'
          result
        )(@)

    constructor: ->
      @model = new Model
      super
      @model.set('modelName', @options.typeToAdd)

    initialize: ->
      @listenTo @, 'quick_add:chosen', =>
        @getUI('inputWrapper').trigger('blur')
      @listenTo @, 'autocomplete', =>
        @getUI('button').trigger('click')

    onAttach: ->
      # temporary fix
      App.vent.trigger('app:view:show', @)
