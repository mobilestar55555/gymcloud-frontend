define ->

  class View extends Marionette.View

    template: (attrs) =>
      if @options.short
        'Delete'
      else
        "Delete #{_.humanize(attrs.type)}"

    tagName: 'button'

    className: 'btn btn-danger gc-action-button type-delete'

    events:
      'click': '_confirmDelete'

    templateContext: ->
      type: @model.type

    _confirmDelete: ->
      App.request('modal:confirm:delete', @model)