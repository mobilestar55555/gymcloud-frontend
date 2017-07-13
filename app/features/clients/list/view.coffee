define [
  './empty/view'
  './item/view'
  './template'
  './move_to_group_modal/view'
  './styles'
], (
  EmptyView
  ItemView
  template
  MoveToGroupModal
  styles
) ->

  class ClientsListView extends Marionette.CompositeView

    key: 'ClientsListView'

    template: template

    className: styles.clients_list

    behaviors:
      auto_complete:
        onItemAdd: (id, $item, selectize) ->
          Backbone.history.navigate("##{@options.path}/#{id}", trigger: true)
        collection: ->
          return @collection if @options.state is 'groups'
          collection = @collection.clone()
          collection.remove(@user.id)
          collection
        serealizeFn: (item) ->
          id: item.get('id')
          name: item.get('name')

    emptyView: EmptyView

    emptyViewOptions: ->
      clientType: @options.clientType

    childView: ItemView

    childViewOptions: ->
      url: @options.path
      state: @options.state

    childViewContainer: '.gc-clients-list'

    childViewEvents:
      'move:single': 'showMoveToGroupModal'
      'checked:single': 'updateState'

    ui:
      moveToGroupBtn: '.move-to-group-show'
      clientsList: '.gc-clients-list'
      mainCheckbox: '.gc-content-nav-checkall input[type="checkbox"]'
      checkedCounter: '.checked-counter'
      removeBtn: '.remove-item'
      buttonsWrapper: ".#{styles.controls}"
      addBtn: '.show-client-form'

    events:
      'click @ui.moveToGroupBtn': 'showMoveToGroupModal'
      'click @ui.mainCheckbox': 'toggleCheck'
      'click @ui.removeBtn': 'removeClientsModal'
      'click @ui.addBtn': 'showAddModal'

    initialize: ->
      @user = App.request('current_user')

    templateContext: ->
      title: @user.user_settings.get('clients_title')
      clientType: @options.clientType
      state: @options.state
      s: styles

    viewComparator: (model) ->
      _.underscored(model.get('name'))

    filter: (model) ->
      @user.id isnt model.get('id') or @options.state is 'groups'

    checkCertificate: ->
      feature.isEnabled('pro_certification') and !@user.get('has_certificate')

    showMoveToGroupModal: ->
      if @user.client_groups.isEmpty()
        App.request('messenger:explain', 'client_groups.empty')
      else
        @modalConstructor(MoveToGroupModal,
          collection: @user.client_groups
          clientIds: @getSelectedIds())

    getSelectedIds: ->
      @getUI('clientsList').find(':checked').map( (i, el) -> $(el).data('id'))

    showAddModal: ->
      if @checkCertificate()
        App.request('modal:certificate:upload', 'add_client')
      else
        @modalConstructor(@options.modalViewClass,
          collection: @collection
          model: new @options.modalModelClass
          clientType: @options.clientType)

    modalConstructor: (modal, data) ->
      view = new modal(data)
      @listenToOnce(view, 'close:modal', -> region.$el.modal('hide'))
      region = App.request('app:layouts:base').getRegion('modal')
      $(region.el).show()
      region.show(view)
      region.$el.modal('show')

    toggleCheck: ->
      checked = @getUI('mainCheckbox').is(':checked')
      @getUI('clientsList').find('input[type=checkbox]')
        .prop('checked', checked)
      @updateButtonsState()

    updateButtonsState: ->
      count = @getUI('clientsList').find(':checked').length
      @getUI('buttonsWrapper').toggleClass('hidden', !count)
      @getUI('checkedCounter').text(count)

    updateState: ->
      @updateButtonsState()
      all = @getUI('clientsList').find('input[type=checkbox]').length
      checked = @getUI('clientsList').find(':checked').length
      @getUI('mainCheckbox').prop 'checked', all is checked

    removeClientsModal: ->
      App.request 'modal:confirm',
        title: 'Delete items'
        content: 'Are you sure you want to delete selected items?'
        confirmBtn: 'Delete'
        confirmCallBack: =>
          @removeClientsCallback()

    removeClientsCallback: ->
      ids = @getSelectedIds()
      deletions = _.map ids, (id) =>
        model = @collection.get(id)
        model.destroy(wait: true)
      $.when(deletions...)
        .then =>
          App.request('messenger:explain', 'item.deleted')
          @updateButtonsState()
        .fail ->
          App.request('messenger:explain', 'item.not_deleted')

    onAttach: ->
      # temporary fix
      App.vent.trigger('app:view:show', @)
