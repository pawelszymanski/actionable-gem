class @Switch

  constructor: (element) ->

    selector = Utils.initRawDataAttr element, 'selector', Constants.STRING, '> *'
    klass = Utils.initRawDataAttr element, 'class', Constants.STRING, 'active'
    event = Utils.initRawDataAttr element, 'event', Constants.STRING, 'click'
    binded = Utils.initRawDataAttr element, 'bind', Constants.STRING, Constants.EMPTY
    bindedClass = Utils.initRawDataAttr element, 'binded_class', Constants.STRING, 'active'

    event = event + '.actionable.switch'

    element.find(selector).on event, ->
      if Helpers.isEnabled this
        element.find(selector).removeClass klass
        $(this).addClass klass
        if binded isnt Constants.EMPTY
          $(binded).removeClass bindedClass
          $(binded).eq(element.find(selector).index($(this))).addClass bindedClass


