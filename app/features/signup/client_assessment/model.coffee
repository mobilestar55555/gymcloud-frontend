define ->

  class AssessmentReportModel extends Backbone.Model

    url: '/client_assessments'

    defaults:
      gender: undefined
      birthday: ''
      height: undefined
      weight: undefined
      reason: undefined
      equipment: []
      improve_option: undefined
      improve: undefined
      impact: undefined

    computed: ->
      height_feet:
        depends: ['height']
        get: (attrs) ->
          Math.floor(attrs.height / 12)
        set: (value, attrs) ->
          value = parseInt(value, 10) or 0
          inches = parseInt(@get('height_inches')) or 0
          attrs.height = value * 12 + inches
        toJSON: false

      height_inches:
        depends: ['height']
        get: (attrs) ->
          (attrs.height % 12)
        set: (value, attrs) ->
          value = parseInt(value, 10) or 0
          feet = @get('height_feet') or 0
          attrs.height = feet * 12 + value
        toJSON: false

      date_of_birth:
        depends: ['birthday']
        get: (attrs) ->
          parts = attrs.birthday.split('-')
          return '' if parts.length isnt 3
          "#{parts[1]}/#{parts[2]}/#{parts[0]}"
        set: (value, attrs) ->
          parts = value.split('/')
          return '' if parts.length isnt 3
          attrs.birthday = "#{parts[2]}-#{parts[0]}-#{parts[1]}"
        toJSON: false

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)
