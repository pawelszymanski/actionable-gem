class @ReplaceText

  replaceText = (sender, target, newText) ->
    if Helpers.isEnabled sender
      currentText = target.text()
      target.text newText
      sender.attr 'data-alt_text', currentText

  constructor: (element) ->

    altText = Utils.initRawDataAttr element, 'alt_text', Constants.STRING, Constants.EMPTY
    target = Utils.initRawDataAttr element, 'target', Constants.STRING, Constants.SELF
    events = Utils.initRawDataAttr element, 'events', Constants.STRING
    if events?
      eventReplace = events
      eventRestore = events
    else
      eventReplace = Utils.initRawDataAttr element, 'event_replace', Constants.STRING, 'mouseenter'
      eventRestore = Utils.initRawDataAttr element, 'event_restore', Constants.STRING, 'mouseleave'

    eventReplace = eventReplace + '.actionable.replace_text'
    eventRestore = eventRestore + '.actionable.replace_text'

    target = if target is Constants.SELF then element else $(target)

    if eventReplace is eventRestore
      element.on eventReplace, =>
        replaceText element, target, Utils.getRawDataAttr(element, 'alt_text')
    else
      Utils.setRawDataAttr(element, 'next_action', Constants.REPLACE)
      element.on eventReplace, =>
        if (Utils.getRawDataAttr(element, 'next_action')) is Constants.REPLACE
          replaceText element, target, altText
          Utils.setRawDataAttr(element, 'next_action', Constants.RESTORE)
      element.on eventRestore, =>
        if (Utils.getRawDataAttr(element, 'next_action')) is Constants.RESTORE
          replaceText element, target, Utils.getRawDataAttr(element, 'alt_text')
          Utils.setRawDataAttr(element, 'next_action', Constants.REPLACE)


