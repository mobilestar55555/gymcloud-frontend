define [
  '../q5/view'
], (
  ImprovementOptionSelectView
) ->

  class Question6View extends ImprovementOptionSelectView

    view_id: 6

    view_count: 9

    questionNumber: 6

    titleText: 'Choose the aspect of "Improve my Performance" that is most
                important to you.'

    improveOptions: [
        id: 5
        text: 'Athletic Performance Improvements'
      ,
        id: 6
        text: 'More active lifestyle'
      ,
        id: 7
        text: 'Prevent or rehabilitate an Injury'
    ]

    next_view_key: '5'

    initialize: ->

    _isValid: ->
      @model.get('improve_option') in ['5', '6', '7']

    getNextViewKey: ->
      key = @model.get('improve_option') - 4
      "7_#{key}"
