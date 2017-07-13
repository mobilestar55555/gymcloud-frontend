define [
  '../q6_1/view'
], (
  Question6_1View
) ->

  class Question7View extends Question6_1View

    view_id: 7

    view_count: 9

    questionNumber: 7

    titleText: 'Choose the aspect of "More active lifestyle" that is
            most important to you.'

    improveOptions: [
        text: 'I want to perform better at work'
      ,
        text: 'I want to be more physically active with my friends and family'
      ,
        text: 'I want to make fitness more varied, fun and enjoyable'
    ]
