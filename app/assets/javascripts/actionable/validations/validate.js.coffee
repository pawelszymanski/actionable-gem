class @Validate

  constructor: (element) ->
    @input = $(element)

    @form = $(@input).parents("form")
    unless @form.length is 1
      Utils.debugMessage 'Inputs and textareas are required to have one and only one form parent, inspect the following:', @input
      return

    @formLevelEvents = Utils.initRawDataAttr @form, 'events', Constants.STRING, 'blur'
    @formLevelLabels = Utils.initRawDataAttr @form, 'labels', Constants.STRING, Constants.EMPTY
    @formLevelIcons = Utils.initRawDataAttr @form, 'icons', Constants.STRING, Constants.EMPTY
    @formLevelResults = Utils.initRawDataAttr @form, 'results', Constants.STRING, Constants.EMPTY

    @pattern = Utils.initRawDataAttr @input, 'validate', Constants.REGEXP, Constants.EMPTY, Constants.REQUIRED
    @textPass = Utils.initRawDataAttr @input, 'text_pass', Constants.STRING, 'Passed'
    @textFail = Utils.initRawDataAttr @input, 'text_fail', Constants.STRING, 'Failed'
    @events = Utils.initRawDataAttr @input, 'events', Constants.STRING, @formLevelEvents
    @label = Utils.initRawDataAttr @input, 'label', Constants.STRING, @formLevelLabels
    @icon = Utils.initRawDataAttr @input, 'icon', Constants.STRING, @formLevelIcons
    @result = Utils.initRawDataAttr @input, 'result', Constants.STRING, @formLevelResults

    if @label  is Constants.EMPTY then @label =  @input.prevAll('label:last')     else @label =  @input.prevAll @label
    if @icon   is Constants.EMPTY then @icon =   @input.nextAll('.icon:first')    else @icon =   @input.nextAll @icon
    if @result is Constants.EMPTY then @result = @input.nextAll('p.result:first') else @result = @input.nextAll @result

    @elementAndHelpers = @input.add(@label).add(@icon).add(@result)

    @events = @events.split(' ').trimStrings().removeEmptyStrings().unduplicate()
    for anEvent in @events
      anEvent = anEvent + '.actionable.validate'
      @input.on anEvent, =>
        @elementAndHelpers.removeClass('failed').removeClass 'passed'
        if Validations.validate(@input.val(), @pattern)
          @elementAndHelpers.addClass('passed')
          @result.text @textPass
        else
          @elementAndHelpers.addClass('failed')
          @result.text @textFail


