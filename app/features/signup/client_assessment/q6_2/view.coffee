define [
  '../q6_1/view'
], (
  Question6_1View
) ->

  class Question6View extends Question6_1View

    questionNumber: 6

    titleText: 'Choose the aspect of "Improve My Physical Appearance" that is
            most important to you.'
    improveOptions: [
        text: 'I want to lose weight'
      ,
        text: 'I want to build lean muscle mass'
      ,
        text: 'I want to gain weight "bulk up"'
      ,
        text: '' # Other please explain
    ]
