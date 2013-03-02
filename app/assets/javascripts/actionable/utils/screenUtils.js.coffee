class ScreenUtils

  constructor: ->



  documentWidth: =>           # Scrollbar width is not included.
    $('body').outerWidth()

  documentHeight: =>          # Scrollbar height is not included.
    $('body').outerHeight()



  viewportWidth: =>
    $(window).width()

  viewportHeight: =>
    $(window).height()



  screenWidth: =>
    window.screen.width

  screenHeight: =>
    window.screen.height



  documentScrollTop: (offset) =>     # Chrome uses 'body'. IE, Opera and FF are operate on 'html'.
    if offset? $('body, html').scrollTop offset else Math.max($('body').scrollTop(), $('html').scrollTop())

  documentScrollLeft: (offset) =>    # Chrome uses 'body'. IE, Opera and FF are operate on 'html'.
    if scrollOffset? then $('body, html').scrollLeft offset else Math.max($('body').scrollLeft(), $('html').scrollLeft())



  scrollbarWidth: =>
    if window.BrowserUtils.isHandheld()
      return 0
    else
      html = "<div style='position: absolute; top: 0; left: 0; z-index: -1; width: 100%; height: 80px; overflow: scroll;'><div style='width: 100%; height: 90px;'></div></div>"
      $('body').prepend(html)
      testElem = $('body').children().eq(0)
      scrollbarWidth = testElem.innerWidth() - testElem.children().eq(0).innerWidth()
      testElem.remove()
      return scrollbarWidth



@ScreenUtils = new ScreenUtils


