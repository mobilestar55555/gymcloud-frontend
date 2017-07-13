define [
  './template'
], (
  template
) ->

  class EmptyView extends Marionette.View

    template: template

    templateContext: ->
      resource: @resource
      resources: @resources

    behaviors: ->

      stickit:
        bindings:
          '.gc-exercises-assign-add':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (_value) ->
                  user = App.request('current_user')
                  rootFolder = user.library.first()
                  name = @_templatesFolderName()
                  folder = rootFolder.nestedFolders.findWhere({name: name})
                  folder.get('link')
            ]

    initialize: ->
      name = _.chain(@options.type)
        .humanize()
        .words()
        .last()
        .value()
      @resources = name
      @resource = _.singularize(name)

    _templatesFolderName: ->
      {
        personal_programs: 'Program Templates'
        personal_workouts: 'Workout Templates'
        personal_warmups: 'Warmup Templates'
        personal_cooldowns: 'Cooldown Templates'
        personal_exercises: 'Exercises'
      }[@options.type]
