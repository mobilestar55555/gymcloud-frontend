define [
  'behaviors/base/regioned'
  './view'
], (
  BaseRegionedBehavior
  View
) ->

  class Behavior extends BaseRegionedBehavior

    regionName: 'editable_textarea'

    behaviorViewClass: View

    behaviorViewOptions: ->
      model = _.bind(@options.model, @)
      model: model
      readonly: @options.readonly

    defaults:
      model: ->
        @view.model
