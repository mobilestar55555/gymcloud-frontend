define [
  '../q6_1/view'
], (
  Question6_1View
) ->

  class Question7View extends Question6_1View

    view_id: 7

    view_count: 9

    questionNumber: 7

    titleText: 'Choose the aspect of "Prevent or rehabilitate an Injury" that is
            most important to you.'

    improveOptions: [
        text: 'I want to decrease my risk of future injuries'
      ,
        text: 'I want to rehab an existing injury or injuries'
    ]
