define [
  'models/program_week'
], (
  ProgramWeek
) ->

  class ProgramWeeks extends Backbone.Collection

    type: 'ProgramWeeks'

    model: ProgramWeek

    url: ->
      root = _.chain(@program.type).underscore().pluralize().value()
      "/#{root}/#{@program.id}/program_weeks"

    comparator: 'position'
