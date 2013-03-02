class @Activate

  constructor: (element) ->
    target = Utils.initRawDataAttr element, 'target', Constants.STRING, Constants.SELF
    event = Utils.initRawDataAttr element, 'event', Constants.STRING, 'click'
    klass = Utils.initRawDataAttr element, 'class', Constants.STRING, 'active'
    mode = Utils.initRawDataAttr element, 'mode', Constants.STRING, 'toggle'

    target = if target is Constants.SELF then $(element) else $(target)
    event = event + '.actionable.activate'
    action = switch mode
      when 'toggle'
        'toggleClass'
      when 'add'
        'addClass'
      when 'remove'
        'removeClass'

    element.on event, ->
      target[action](klass)


