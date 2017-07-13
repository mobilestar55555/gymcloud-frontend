define ->

  class Model extends Backbone.Model

    defaults:
      id: undefined
      title: undefined
      active: false
      hidden: false
      enabled: -> true
