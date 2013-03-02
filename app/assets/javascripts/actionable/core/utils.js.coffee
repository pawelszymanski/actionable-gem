class Utils

  debugMessage: (message, element) ->
    console.log 'Actionable: ' + message
    console.log element  if element?

  getRawDataAttr: (element, attribute) ->
    $(element).attr 'data-' + attribute

  setRawDataAttr: (element, attribute, value) ->
    $(element).attr 'data-' + attribute, value

  initRawDataAttr: (element, attribute, type, defaultValue, isRequired) ->
    value = @getRawDataAttr element, attribute
    value = defaultValue  if typeof value is 'undefined'
    switch type
      when Constants.STRING
        value = value
      when Constants.INTEGER_POSITIVE
        value = if value > 0 then value * 1 else defaultValue
      when Constants.INTEGER_NOT_NEGATIVE
        value = if value >= 0 then value * 1 else defaultValue
      when Constants.BOOLEAN
        value = if value in [true, 'true', 'yes', 'on', 1, '1'] then true else false
      when Constants.REGEXP
        value = defaultValue  unless Validations.isPredefinedRegExp(value) or /^\/.+\/$/.test(value)
    @setRawDataAttr element, attribute, value
    if isRequired is Constants.REQUIRED and value is defaultValue
      @debugMessage "'data-" + attribute + "' is required, but it's " + Constants.constToHumanString(defaultValue) + ", inspect the following:", element
    return value



@Utils = new Utils


