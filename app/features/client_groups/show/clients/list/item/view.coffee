define [
  './template'
], (
  template
) ->

  class MembersItemView extends Marionette.View

    template: template

    tagName: 'li'

    className: 'row padding-0'
