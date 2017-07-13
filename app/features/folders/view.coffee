define [
  './entity_list/view'
  './add_entity_modal/view'
  './add_folder_modal/view'
  './duplicate_modal/view'
  './template'
  './autocomplete'
], (
  EntityListView
  AddEntityModalView
  AddFolderModalView
  DuplicateModalView
  template
  autocompleteTemplate
) ->

  class FolderListView extends Marionette.View

    key: 'FolderListView'

    template: template

    regions:
      collectionRegion: 'region[data-name="collection"]'
      modalRegion: '#gc-modal-region'

    ui:
      liveSearch: '.live-search'
      mainCheckbox: '.gc-content-nav-checkall input'
      collectionRegion: 'region[data-name="collection"]'
      folderAddButton: '.gc-show-add-exercise-folder-modal'
      folderEditButton: '.gc-show-edit-folder-modal'
      itemAddButton: '.gc-show-add-exercise-modal'
      itemDuplicateButton: '.gc-show-duplicate-modal'
      itemDeleteButton: '[data-action="remove"]'
      actionModal: '#gc-modal-region'
      itemCheckBox: '.gc-exercises-chb input'

    events:
      'click @ui.mainCheckbox': 'toggleCheck'
      'click @ui.folderAddButton': '_showAddFolderModal'
      'click @ui.folderEditButton': '_showEditFolderModal'
      'click @ui.itemAddButton': '_showAddEntityModal'
      'click @ui.itemDuplicateButton': '_showDuplicateModal'
      'click @ui.itemDeleteButton': '_showDestroySelectedModal'
      'change @ui.itemCheckBox': '_toggleActionsBtnVisibility'

    behaviors: ->

      navigate_back: true

      breadcrumbs: true

      auto_complete:
        onItemAdd: (id, $item, selectize) ->
          Backbone.history.navigate("##{@typeName}/#{id}", trigger: true)
        collection: =>
          App.request('current_user')[@typeName]
        serealizeFn: (item) ->
          folder: item.folder?.name
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')
        render:
          option: (item, escape) ->
            autocompleteTemplate(item)
        create: true

      stickit:
        bindings:
          '.gc-show-edit-folder-modal':
            observe: 'id'
            visible: (value) ->
              user = App.request('current_user')
              rootFolder = user.library.first()
              ids = rootFolder.items.pluck('id')
              !_.contains(ids.concat(rootFolder.id), value)

          '.gc-content-nav-back':
            observe: 'id'
            visible: (value) ->
              user = App.request('current_user')
              rootFolder = user.library.first()
              ids = rootFolder.items.pluck('id')
              !_.contains(ids.concat(rootFolder.id), value)

    templateContext: ->
      type: @typeName
      singularName: @singularName

    initialize: (data) ->
      @collection = data.items
      @typeName = data.type
      @singularName = _.chain(@typeName).humanize().singularize().value()
      $(document).on "click.#{@cid}", 'button.clickable', (ev) =>
        @_duplicateToThisFolder(ev)

    onBeforeDestroy: ->
      $(document).off("click.#{@cid}")

    onAttach: ->
      @_showEntityList()

    _toggleActionsBtnVisibility:->
      checked = $('.gc-exercises-chb input[type=checkbox]:checked').length > 0
      showDuplicateBtn = checked && @model.nestedFolders.length > 0
      @getUI('itemDeleteButton').toggleClass 'disp-none', !checked
      @getUI('itemDuplicateButton').toggleClass 'disp-none', !showDuplicateBtn

    _showEntityList: ->
      @listView = new EntityListView
        collection: @collection
        type: @typeName
      @showChildView('collectionRegion', @listView)

      @listenTo(@listView, 'item:clicked', @_updateSelectedItems)

    toggleCheck: (ev) =>
      checked = @getUI('mainCheckbox').is(':checked')
      @getUI('collectionRegion')
        .find('input[type=checkbox]')
        .prop('checked', checked)
      @_toggleActionsBtnVisibility()

    _updateSelectedItems: ->
      for check in @getUI('collectionRegion').find('input[type=checkbox]')
        if needToggle?
          if needToggle != $(check).is(':checked')
            @getUI('mainCheckbox').prop 'checked', false
            return
        needToggle = $(check).is(':checked')
      if needToggle
        @getUI('mainCheckbox').prop 'checked', true

    _showDestroySelectedModal: (ev) =>
      App.request 'modal:confirm',
        title: 'Delete item(s)'
        content: 'Are you sure you want to delete selected items?'
        confirmBtn: 'Delete'
        confirmCallBack: @_onDestroyConfirm

    _onDestroyConfirm: =>
      checked = @getUI('collectionRegion').find('input[type=checkbox]:checked')
      ids = checked.map( (_index, el) -> $(el).closest('li').data('id') )
      @listView.trigger('items:delete', ids, @model.get('id'))

    _showAddEntityModal: (ev) ->
      view = new AddEntityModalView
        folder: @model
        type: @typeName

      @showChildView('modalRegion', view)
      @getUI('actionModal').modal('show')

    _showAddFolderModal: (ev) ->
      view = new AddFolderModalView
        parent: @model
        type: @typeName

      @showChildView('modalRegion', view)
      @getUI('actionModal').modal('show')

    _showEditFolderModal: ->
      App.request 'modal:prompt',
        title: 'Edit Folder Name'
        confirmBtn: 'Rename'
        cancelCallBack: -> # nothing
        confirmCallBack: (name) => @model.patch(name: name)

    _showDuplicateModal: (ev) =>
      view = new DuplicateModalView
        collection: @model.nestedFolders
        type: @typeName

      @listenToOnce(view, 'items:duplicate', @_duplicateEntity)

      @showChildView('modalRegion', view)
      @getUI('actionModal').modal('show')

    _duplicateEntity: (folderId) ->
      checked = @getUI('collectionRegion').find('input[type=checkbox]:checked')
      ids = checked.map( (_index, el) -> $(el).data('id') )

      if ids.length and folderId
        ids.each (id) =>
          item = @collection.findWhere 'id': ids[id]
          item.save('folder_id': folderId)
            .then =>
              profileModel = App.request 'current_user'
              folder = profileModel.folders.get(folderId)
              folder.items.add item
              @collection.remove item
              @_onDuplicate()
      else
        App.request('messenger:explain', 'item.not_selected')

    _onDuplicate: (response) =>
      @getUI('actionModal').modal('hide')
      App.request('messenger:explain', 'item.duplicated')

    _duplicateToThisFolder: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      id = $(ev.currentTarget).data('id')
      @collection.duplicate(
        ids: [id]
        foldersIds: [@model.id]
      ).then(@_onDuplicate)
