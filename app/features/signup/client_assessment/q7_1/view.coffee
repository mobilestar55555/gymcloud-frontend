define [
  '../q6_1/view'
], (
  Question6_1View
) ->

  class Question7View extends Question6_1View

    view_id: 7

    view_count: 9

    questionNumber: 7

    titleText: 'Choose the aspect of "Athletic Performance Improvements" that is
            most important to you.'

    improveOptions: [
        text: 'I want to improve strength'
      ,
        text: 'I want to increase my stamina and endurance'
      ,
        text: 'I want to improve my mobility, stability and flexibility'
    ]
