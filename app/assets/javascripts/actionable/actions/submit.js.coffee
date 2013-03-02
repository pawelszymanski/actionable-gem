class @Submit

  submitNearestForm = (element, event) ->
    if Helpers.isEnabled element
      element.parents('form').submit()
      event.preventDefault()
      event.stopImmediatePropagation()

  constructor: (element) ->
    events = Utils.initRawDataAttr element, 'events', Constants.STRING, 'click'
    events = events.split(/,| /).trimStrings().removeEmptyStrings()

    for anEvent in events

      if anEvent is 'click'
        element.on 'click.actionable.submit', (event) =>
          submitNearestForm(element, event)

      if anEvent is 'enterKeyPressed'
        element.on 'keydown.actionable.submit', (event) =>
          if KeyboardUtils.decodeKeyCode(event.keyCode) is 'Enter'
            submitNearestForm(element, event)


