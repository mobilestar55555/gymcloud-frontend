define [
  './item/view'
], (
  ItemView
) ->

  class RecentEventsNotifications extends Marionette.CollectionView

    className: 'gc-recent-activity'

    childView: ItemView

    initialize: ->
      @setActionCable()

    setActionCable: ->
      id = App.request('current_user_id')
      key = "notifications_#{id}"
      fn = (data) =>
        @collection.unshift(data.notification) if data

      App.request('cable:register', key, 'NotificationsChannel', received: fn)
      App.request('cable:subscribe', key)

      # for future
      # msg_key = "messages_#{id}"
      # App.request('cable:register', msg_key, 'MessagesChannel', received: fn)
      # App.request('cable:subscribe', msg_key)

      @listenTo @, 'destroy garbage', ->
        App.request('cable:unsubscribe:all')
        App.request('cable:unregister:all')
