define ->

  (Marionette) ->
    Marionette.Controller = Marionette.Object.extend

      constructor: (@options = {}) ->
        args = Array::slice.call(arguments)
        args[0] = @options
        Marionette.Object::constructor.apply(@, args)
        return

      destroy: (args...) ->
        @triggerMethod.apply(@, ['before:destroy'].concat(args))
        @triggerMethod.apply(@, ['destroy'].concat(args))
        @stopListening()
        @
