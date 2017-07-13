define [
  './item/view'
  './collection'
], (
  AccountTypeItemView
  UserAccountTypesCollection
) ->

  class AccountTypeListView extends Marionette.CollectionView

    tagName: 'ul'

    childView: AccountTypeItemView

    initialize: ->
      @settings = App.request('current_user').user_settings
      accountType = @settings.get('user_account_type_id')
      @collection = new UserAccountTypesCollection
      @collection.fetch()
        .then =>
          return if accountType
          model = @collection.first()
          @settings.set(user_account_type_id: model.id)
          model.set(is_selected: true)

    saveAccountType: ->
      if @settings.get('user_account_type_id')
        request = @settings.save({}, wait: true)
        request.then ->
          App.request('messenger:explain', 'user.account_type.changed')
        request
      else
        App.request('messenger:explain', 'user.account_type.not_selected')
        false
