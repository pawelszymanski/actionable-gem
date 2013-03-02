class @ScrollTo

  show: =>
    @scrollTo.fadeIn @fadeSpeed

  hide: =>
    @scrollTo.fadeOut @fadeSpeed

  update: =>
    if ScreenUtils.documentScrollTop() >= @scrollFreeZone then @show() else @hide()

  scroll: =>
    destinationPx = @getDestinationInPx()
    unless destinationPx is undefined
      clearTimeout(@timer)
      @scrolling = true
      $('html, body').animate( scrollTop: destinationPx, @scrollSpeed, =>   # Chrome uses 'body'. IE, Opera and FF are operate on 'html'.
        @scrolling = false
        window.location.hash = @destination  if $("a[name='#{@destination}']").length is 1
      )

  getDestinationInPx: =>
    return @destination  if (@destination.toString().isMadeOfDigitsOnly()) and (@destination >= 0)    # Types rely on jQuery doing auto-conversion of data attributes to numbers
    anchors = $("a[name='#{@destination}']")
    elements = $(@destination)
    return anchors.offset().top  if (anchors.length is 1) and (elements.length isnt 1)
    return elements.offset().top  if (elements.length is 1) and (anchors.length isnt 1)
    Utils.debugMessage "'data-destination' has to be a not negative number or point to unique anchor/DOM element, inspect the following:", @scrollTo
    return undefined

  constructor: (@element) ->
    @scrollTo = $(@element)
    @scrollTo.data('scroll_to_object', this)

    @destination = Utils.initRawDataAttr @scrollTo, 'destination', Constants.STRING, 0
    @scrollFreeZone = Utils.initRawDataAttr @scrollTo, 'scroll_free_zone', Constants.INTEGER_NOT_NEGATIVE, 0
    @scrollSpeed = Utils.initRawDataAttr @scrollTo, 'scroll_speed', Constants.INTEGER_POSITIVE, 500
    @fadeSpeed = Utils.initRawDataAttr @scrollTo, 'fade_speed', Constants.INTEGER_POSITIVE, 200
    @throttle = Utils.initRawDataAttr @scrollTo, 'throttle', Constants.INTEGER_NOT_NEGATIVE, 50

    @timer = null
    @scrolling = false

    @scrollTo.on 'click.actionable.scroll_to', =>
      @scroll()

    $(window).on 'scroll.actionable.scroll_to resize.actionable.scroll_to', =>
      unless @scrolling is true
        clearTimeout(@timer)
        @timer = setTimeout( =>
          @update()
        , @throttle)

    @update()



$ ->



  $.fn.scrollTo = ->
    $(this).filter("[data-widget~='scroll_to']").first().data('scroll_to_object')


