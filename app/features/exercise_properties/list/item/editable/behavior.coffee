define [
  'features/properties/select_box/view'
  'features/property_unit_selector/view'
  './value/view'
], (
  PropertiesSelectBox
  PropertyUnitSelectorCollectionView
  PropertyValueView
) ->

  class EditableExercisePropertyBehavior extends Marionette.Behavior

    key: 'editable_exercise_property'

    behaviors:

      regioned:
        views: [
            region: 'properties_select_box'
            klass: PropertiesSelectBox
            replaceElement: true
            options: ->
              property = unless @model.get('personal_property_id')
                name: 'Property'
                global_property:
                  unit: ''
              else
                @model.get('personal_property')

              default_property: property
          ,
            region: 'property_unit_selector'
            klass: PropertyUnitSelectorCollectionView
            replaceElement: true
            options: ->
              units = if @model.isNew()
                []
              else
                @model.personal_property.property_units.models
              @_property_units.reset(units)

              collection: @_property_units
              selected: @model.get('property_unit_id')
          ,
            region: 'property_value'
            klass: PropertyValueView
            replaceElement: true
            options: ->
              model: @model
        ]

    events:
      'click .gc-remove': '_removeProperty'

    initialize: ->
      @view._properties = App.request('data:personal_properties:visible')
      @view._property_units = new Backbone.Collection

    onAttach: ->
      @listenTo(@view.views.properties_select_box, 'selected', @selectProperty)
      @listenTo(@view.views.property_unit_selector, 'selected', @selectUnit)
      @listenTo(@view.views.property_value, 'save_property', @saveProperty)
      @_selectValue()

    selectUnit: (property_unit) ->
      @view.model.setUnit(property_unit)
      @_selectValue()

    selectProperty: (model) ->
      @view.model.setProperty(model)
      unitSelector = @view.views.property_unit_selector
      defaultUnitId = @view.model.get('property_unit_id')
      units = model.property_units.models
      unitSelector.updateUnits(units, defaultUnitId)
      @_rerenderPropertyValue()
      _.chain(unitSelector.showTooltip).bind(unitSelector).delay(0)
      @_selectValue()

    _rerenderPropertyValue: ->
      region = @view.getRegion('property_value')
      currentView = region.currentView
      newView = new PropertyValueView(model: @view.model)
      return if currentView.constructor is newView.constructor
      region.show(newView)

    _removeProperty: (ev) ->
      ev.preventDefault()
      ev.stopImmediatePropagation()
      @view.model.destroy(wait: true)

    _selectValue: ->
      @view.views.property_value.trigger('select_value')

    saveProperty: ->
      @view._saveProperty()
