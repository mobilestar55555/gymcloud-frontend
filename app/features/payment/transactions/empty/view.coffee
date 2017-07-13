define [
  './template'
], (
  template
) ->

  class NoTransactions extends Marionette.View

    template: template

    className: 'no-transactions'
