define [
  './item/view'
  './template'
], (
  ItemView
  template
) ->

  class FolderDuplicateModalView extends Marionette.CompositeView

    template: template

    className: 'modal-dialog modal-md'

    childView: ItemView

    childViewContainer: 'ul'

    ui:
      form: 'form'
      itemsList: '.gc-duplicate-folders-list'

    events:
      'submit @ui.form': 'submitForm'

    initialize: (data) ->
      @typeName = data.type

    templateContext: ->
      type: @typeName
      typeSinglular: _.chain(@typeName).singularize().humanize().value()

    submitForm: (ev) ->
      id = @getUI('itemsList').find(':checked').data('id')
      @trigger('items:duplicate', id)
