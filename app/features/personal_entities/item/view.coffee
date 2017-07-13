define [
  './template'
], (
  itemViewTpl
) ->

  class PersonalEntityItemView extends Marionette.View

    template: itemViewTpl

    tagName: 'li'

    className: 'row gc-folder'

    behaviors: ->

      mobile_only_features: true

      enter_results_for_new_workout_event:
        id: => @model.id

      stickit:
        bindings:
          '.name': 'name'
          '.gc-exercises-link':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: ->
                  if @options.rootUrl is 'exercises'
                    userId = App.request('current_user_id')
                    id = @model.get('exercise_id')
                    "#users/#{userId}/#{@options.rootUrl}/#{id}"
                  else
                    "##{@options.rootUrl}/#{@model.id}"
            ]
          '.gc-client-item-icon':
            attributes: [
                name: 'class'
                observe: 'id'
                onGet: ->
                  "gc-client-item-icon-#{@options.rootUrl}"
            ]
          'span.workout':
            observe: 'workout_name'
            visible: (value) -> !!value
          '.gc-workout-link':
            observe: 'workout_name'
            attributes: [
                name: 'href'
                observe: 'workout_id'
                onGet: (value) ->
                  "#personal_workouts/#{value}"
            ]
          '.schedule-buttons':
            observe: 'id'
            visible: (value) ->
              @options.rootUrl is 'personal_workouts'
