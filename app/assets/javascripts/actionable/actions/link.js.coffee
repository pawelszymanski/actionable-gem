class @Link

  constructor: (element) ->

    url = Utils.initRawDataAttr element, 'url', Constants.STRING, Constants.EMPTY, Constants.REQUIRED
    target = Utils.initRawDataAttr element, 'target', Constants.STRING, Constants.SELF

    element.on 'click.actionable.link', (event) ->
      if Helpers.isEnabled element
        unless event.isDefaultPrevented()    # Back off when event is prevented by some other code
          modKey = if BrowserUtils.OS() is Constants.OS_MAC then event.metaKey else event.ctrlKey
          windowName = if modKey then '_blank' else target
          window.open(url, windowName)


