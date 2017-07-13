define [
  './template'
  './item/view'
  './styles'
], (
  template
  ItemView
  styles
) ->
  class AddMoveModal extends Marionette.CompositeView

    template: template

    className: "modal-dialog modal-md #{styles.add_move_modal}"

    childView: ItemView

    childViewContainer: ".#{styles.list}"

    templateContext:
      s: styles

    behaviors:

      form_validation: true

      stickit:
        bindings:
          '[data-bind="name"]': 'name'

    ui:
      form: 'form'
      foldersList: ".#{styles.list}"

    events:
      'submit @ui.form': 'submitForm'

    viewComparator: (model) ->
      _.underscored(model.get('name'))

    submitForm: ->
      folderId = @getUI('foldersList').find(':checked').data('id') or
        @options.rootFolderId
      @model.set('folder_id', folderId)
      @model.save().then =>
        @options.exercises.add(@model)
        @options.folders.get(folderId).items.add(@model)
        App.vent.trigger('mixpanel:track', 'exercise_created', @model)
        App.request('messenger:explain', 'item.added')
        @trigger 'close:modal', @model.id
        path = "#exercises/#{@model.id}/edit?back"
        App.vent.trigger('redirect:to', path, replace: false)
