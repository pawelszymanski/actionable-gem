class @Toggle

  constructor: (element) ->
    target = Utils.initRawDataAttr element, 'target', Constants.STRING, Constants.SELF
    event = Utils.initRawDataAttr element, 'event', Constants.STRING, 'click'
    effect = Utils.initRawDataAttr element, 'effect', Constants.STRING, Constants.EMPTY
    speed = Utils.initRawDataAttr element, 'speed', Constants.INTEGER_POSITIVE, '200'
    mode = Utils.initRawDataAttr element, 'mode', Constants.STRING, 'toggle'

    target = if target is Constants.SELF then element else $(target)
    event = event + '.actionable.toggle'

    element.on event, (event) ->
#      event.stopPropagation()   # This prevents multiple toggles if element and it's parent reffer to same target in Toggle action...
                                 # ...but it also stop propagating to body and Dropdown curently need click on body to closeAllExpandedDropdowns()
      if Helpers.isEnabled element
        switch effect
          when Constants.EMPTY
            switch mode
              when 'toggle'
                target.toggle()
              when 'show'
                target.show()
              when 'hide'
                target.hide()
          when 'slide'
            switch mode
              when 'toggle'
                target.slideToggle speed
              when 'show'
                target.slideUp speed
              when 'hide'
                target.slideDown speed
          when 'fade'
            switch mode
              when 'toggle'
                target.fadeToggle speed
              when 'show'
                target.fadeIn speed
              when 'hide'
                target.fadeOut speed


