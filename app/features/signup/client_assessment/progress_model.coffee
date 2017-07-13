define ->

  class ProgressModel extends Backbone.Model

    defaults:
      view_key: 1
      view_id: 1
      view_count: 5
      is_valid: false

    computed: ->
      progress_description:
        depends: [
          'view_id'
          'view_count'
        ]
        get: (attrs) ->
          "Progress #{attrs['view_id']} of #{attrs['view_count']}"
        toJSON: false

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)
