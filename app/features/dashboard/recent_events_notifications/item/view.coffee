define [
  './template'
], (
  template
) ->

  class RecentActivitiesNotificationsItemView extends Marionette.View

    template: template

    className: 'gc-activity-block'

    behaviors:
      stickit:
        bindings:
          '.icon':
            attributes: [
              name: 'class'
              observe: 'key'
              onGet: (value) ->
                value.replace('.', '_')
            ]
          '.username': 'owner_full_name'
          '.text':
            observe: 'key'
            onGet: (value) ->
              @getText(value)
          '.link':
            attributes: [
                name: 'href'
                observe: ['key', 'trackable_id']
                onGet: (values) ->
                  root = _.pluralize(values[0].split('.')[0])
                  "##{root}/#{values[1]}"
            ]

    getText: (type) ->
      {
      'personal_workout.create': 'has assigned new workout'
      'personal_program.create': 'has assigned new program'
      'workout_event.create': 'has scheduled new event'
      'user.invitation_accepted': 'has accepted invitation'
      'exercise_result.create': 'has entered new results'
      'comment.create': 'has added a comment'
      }[type]
