define [
  'underscore'
  'underscore.string'
  'deps/vendor/underscore_inflections'
], (
  o_
  Strings
  Inflections
)->
  o_.mixin(compactObject: (o) -> o_.pick(o, o_.identity))
  o_.mixin(Inflections)
  o_.mixin(Strings.exports())
  o_.wrap = o_.o_wrap
  delete o_.o_wrap
  o_
