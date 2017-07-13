define [
  './model'
  './template'
], (
  Model
  template
) ->

  class CompletionRingView extends Marionette.View

    template: template

    behaviors: ->
      stickit:
        bindings:
          '.counter': 'name'
          '.counter-text': 'description'
          '.content':
            attributes: [
                name: 'title'
                observe: 'titleAttr'
            ]
            initialize: ($el) ->
              $el.tooltip()
            destroy: ($el) ->
              $el.tooltip('destroy')
          '.progress':
            attributes: [
                name: 'style'
                observe: ['progress', 'progress_max']
                onGet: (values) ->
                  ['stroke-dasharray:'].concat(values).join(' ')
            ]

    initialize: ->
      @model = new Model _.extend {},
        customName: @options.customName
        description: @options.description
        completed: @options.dataModel.get(@options.listen[0])
        total: @options.dataModel.get(@options.listen[1])
        titleAttr: @options.titleAttr

      events = "change:#{@options.listen[0]} change:#{@options.listen[1]}"
      @listenTo @options.dataModel, events, ->
        @model.set
          completed: @options.dataModel.get(@options.listen[0])
          total: @options.dataModel.get(@options.listen[1])
