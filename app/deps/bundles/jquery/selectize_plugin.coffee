define [
  'selectize'
], (
  Selectize
) ->
  Selectize.define 'option_click', (options) ->
    self = @
    setup = self.setup

    @setup = ->
      setup.apply(self, arguments)
      clicking = false
      # Detect click on a .clickable
      self.$dropdown_content.on 'mousedown click', (e) ->
        if $(e.target).hasClass('clickable')
          if e.type == 'mousedown'
            clicking = true
            self.isFocused = false
            # awful hack to defuse the document mousedown listener
          else
            self.isFocused = true
            self.blur()
            self.clear()
            self.close()
            setTimeout ->
              clicking = false
              # wait until blur has been preempted
        else
          # cleanup in case user right-clicked or dragged off the element
          clicking = false
          self.isFocused = true
        e
      # Intercept default handlers
      self.$dropdown
        .off('mousedown click', '[data-selectable]')
        .on 'mousedown click', '[data-selectable]', ->
          self.onOptionSelect.apply(self, arguments) unless clicking
      self.$control_input.off('blur').on 'blur', ->
        self.onBlur.apply(self, arguments) unless clicking
