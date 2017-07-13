define [
  './template'
  './item/view'
  'models/client_group_member'
  './styles'
], (
  template
  ItemView
  ClientGroupMember
  styles
) ->
  class MoveToGroupView extends Marionette.CompositeView

    className: "modal-dialog modal-sm #{styles.move_to_group_modal}"

    template: template

    templateContext:
      s: styles

    ui:
      form: '.gc-move-to-group-form'

    events:
      'submit @ui.form': 'submitMovetogroupForm'

    childView: ItemView

    childViewContainer: ".#{styles.list}"

    viewComparator: (model) ->
      _.underscored(model.get('name'))

    submitMovetogroupForm: ->
      checked = @getUI('form').find(':checked')
      if !checked.length
        return App.request('messenger:explain', 'item.not_selected')
      promises = []
      groupIds = checked.map( (i, el) -> $(el).data('id'))
      groupIds.each (i, groupId) =>
        @options.clientIds.each (i, clientId) ->
          clientGroupMember = new ClientGroupMember
            clientId: clientId
            groupId: groupId

          promises.push clientGroupMember.save()

      $.when(promises...).then ->
        @trigger('close:modal')
