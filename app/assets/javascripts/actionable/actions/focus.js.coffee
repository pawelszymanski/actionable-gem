class @Focus

  constructor: (element) ->
    target = Utils.initRawDataAttr element, 'target', Constants.STRING, Constants.EMPTY, Constants.REQUIRED
    event = Utils.initRawDataAttr element, 'event', Constants.STRING, 'click'

    event = event + '.actionable.focus'

    element.on event, ->
      $(target).focus()  if Helpers.isEnabled element


