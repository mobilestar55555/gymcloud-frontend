define [
  'deps/vendor/action_cable'
  'config'
], (
  ActionCable
  config
) ->

  class Module

    class Consumer
      instance = null

      constructor: ->
        return instance if instance

        token = App.request('accessToken:get')
        wsUrl = config.api.url.replace('http', 'ws')
        return instance = ActionCable.createConsumer("#{wsUrl}/cable?#{token}")

    class Channels
      classes = {}
      instances = {}

      @registeredList: ->
        classes

      @register: (id, channel, functions) ->
        classes[id] = [channel, functions]

      @unregister: (id) ->
        delete classes[id]

      @unregisterAll: ->
        _.each classes, (value, key, list) ->
          delete list[key]

      @subscriptions: ->
        instances

      @get: (id, params) ->
        return instances[id] if instances[id]

        [channel, functions] = classes[id]
        cable = new Consumer
        options = _.extend(params, {channel: channel})
        instances[id] = cable.subscriptions.create(options, functions)

      @remove: (id) ->
        instances[id]?.unsubscribe()
        delete instances[id]

      @removeAll: ->
        _.each instances, (value, key, list) ->
          value.unsubscribe()
          delete list[key]

    constructor: (@app) ->
      @app.on('start', @_initHandlers)

    _initHandlers: =>
      @app.reqres.setHandlers

        'cable': ->
          new Consumer

        'cable': ->
          Channels.registeredList()

        'cable:register': (id, channel, functions) ->
          Channels.register(id, channel, functions)

        'cable:unregister': (id) ->
          Channels.unregister(id)

        'cable:subscriptions': ->
          Channels.subscriptions()

        'cable:subscribe': (id, params = {}) ->
          Channels.get(id, params)

        'cable:unsubscribe': (id) ->
          Channels.remove(id)

        'cable:unregister:all': ->
          Channels.unregisterAll()

        'cable:unsubscribe:all': ->
          Channels.removeAll()
