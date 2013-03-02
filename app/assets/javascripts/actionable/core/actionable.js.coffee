class Actionable

  setAlreadyPharsed: (element) ->
    Utils.setRawDataAttr $(element), 'pharsed', 'true'

  isAlreadyPharsed: (element) ->
    if Utils.getRawDataAttr($(element), 'pharsed') is 'true' then true else false

  majorDataAttributesToLowerCase: (selector) ->
    $(selector + ' [data-action]', selector + ' [data-widget]').each (index, element) =>
      Utils.setRawDataAttr $(element), 'action', Utils.getRawDataAttr($(element), 'action').toLowerCase()
      Utils.setRawDataAttr $(element), 'widget', Utils.getRawDataAttr($(element), 'widget').toLowerCase()

  initActionablesInSelector: (selector) ->
    @majorDataAttributesToLowerCase(selector)

    $(selector + ' [data-action]').each (index, element) =>
      unless @isAlreadyPharsed element
        actionTypes = Utils.getRawDataAttr($(element), 'action')
        new Activate($(element))     unless actionTypes.indexOf('activate') is -1
        new Focus($(element))        unless actionTypes.indexOf('focus') is -1
        new Link($(element))         unless actionTypes.indexOf('link') is -1
        new Pushable($(element))     unless actionTypes.indexOf('pushable') is -1
        new ReplaceText($(element))  unless actionTypes.indexOf('replace_text') is -1
        new Submit($(element))       unless actionTypes.indexOf('submit') is -1
        new Switch($(element))       unless actionTypes.indexOf('switch') is -1
        new Toggle($(element))       unless actionTypes.indexOf('toggle') is -1
        new Truncate($(element))     unless actionTypes.indexOf('truncate') is -1
        new Visibility($(element))   unless actionTypes.indexOf('visibility') is -1
        @setAlreadyPharsed element

    $(selector + ' [data-widget]').each (index, element) =>
      unless @isAlreadyPharsed element
        widgetType = Utils.getRawDataAttr($(element), 'widget')
        new Autocomplete(element)  if widgetType is 'autocomplete'
        new Datepicker(element)    if widgetType is 'datepicker'
        new Dropdown(element)      if widgetType is 'dropdown'
        new DynamicGrid(element)   if widgetType is 'dynamic_grid'
        new Hintbox(element)       if widgetType is 'hintbox'
        new ProgressBar(element)   if widgetType is 'progress_bar'
        new ScrollBar(element)     if widgetType is 'scroll_bar'
        new ScrollTo(element)      if widgetType is 'scroll_to'
        new Slider(element)        if widgetType is 'slider'
        new Tooltip(element)       if widgetType is 'tooltip'
        @setAlreadyPharsed element

    $(selector + " input[type='checkbox']").each (index, element) =>
      unless @isAlreadyPharsed element
        new Checkbox $(element)
        @setAlreadyPharsed element

    $(selector + " input[type='radio']").each (index, element) =>
      unless @isAlreadyPharsed element
        new Radio $(element)
        @setAlreadyPharsed element

    $(selector + ' [data-validate]').each (index, element) =>
      unless @isAlreadyPharsed element
        new Validate(element)
        @setAlreadyPharsed element


@Actionable = new Actionable



$ ->

  window.Actionable.initActionablesInSelector('body')

  $(document).ajaxSuccess ->
    window.Actionable.initActionablesInSelector('body')


