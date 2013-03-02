class @ScrollBar

  initialize: =>

    # Wrap inner HTML with .scrollable_content
    @viewport.find('*').wrapAll("<div class='scrollable_content'></div>")
    @content = @viewport.find('> .scrollable_content')

    # Remove pure CSS overflowing, add position relative to viewport, so content can be positioned absolutely
    # Chrome, IE and Opera need to have top and left values assigned, if not they return 'auto' instead of offset
    @viewport.css
      overflow: 'hidden'
      'overflow-x': 'hidden'
      'overflow-y': 'hidden'
      position: 'relative'
    @content.css
      position: 'absolute'
      top: 0
      left: 0

    # Calculate initial viewport and content dimensions, take no border and padding into account
    @viewportWidth =  @viewport.innerWidth()
    @viewportHeight = @viewport.innerHeight()
    @contentWidth =   @content.innerWidth()
    @contentHeight =  @content.innerHeight()

    # Check if there's a need to add a scroll
    @vertical = if @contentHeight > @viewportHeight then true else false
    @horizontal = if @contentWidth > @viewportWidth then true else false

    # Create scrollbars if needed
    if @vertical
      html = ("<div class='scroll_bar vertical'><div class='up'></div><div class='track'><div class='drag'></div></div><div class='down'></div></div>")
      @viewport.append(html)
      @vScrollBar = @viewport.find('.scroll_bar.vertical')
      @up = @vScrollBar.find('> .up')
      @down = @vScrollBar.find('> .down')
      @vTrack = @vScrollBar.find('> .track')
      @vDrag = @vTrack.find('> .drag')
    if @horizontal
      html = ("<div class='scroll_bar horizontal'><div class='left'></div><div class='track'><div class='drag'></div></div><div class='right'></div></div>")
      @viewport.append(html)
      @hScrollBar = @viewport.find('.scroll_bar.horizontal')
      @left = @hScrollBar.find('> .left')
      @right = @hScrollBar.find('> .right')
      @hTrack = @hScrollBar.find('> .track')
      @hDrag = @hTrack.find('> .drag')

    # Chceck if to add padding and recalculate dimensions
    if @vertical and @paddingFix isnt 0
      contentPaddingRight = parseInt(@content.css('padding-right').replace('px', ''))
      @content.css( 'padding-right': contentPaddingRight + @paddingFix )
      @contentWidth = @contentWidth - contentPaddingRight
      @contentHeight = @content.innerHeight()
    if @horizontal and @paddingFix isnt 0
      contentPaddingBottom = parseInt(@content.css('padding-bottom').replace('px', ''))
      @content.css( 'padding-bottom': contentPaddingBottom + @paddingFix )
      @contentHeight = @contentHeight - contentPaddingBottom
      @contentWidth = @content.innerWidth()

    # Calculate navigation button dimensions
    if @vertical
      @navUpHeight =   if @up.length is 1    then parseInt(@up.css('height').replace('px', ''))   else 0
      @navDownHeight = if @down.length is 1  then parseInt(@down.css('height').replace('px', '')) else 0
    if @horizontal
      @navLeftWidth =  if @left.length is 1  then parseInt(@left.css('width').replace('px', ''))  else 0
      @navRightWidth = if @right.length is 1 then parseInt(@right.css('width').replace('px', '')) else 0

    # Position track elements and get their dimensions
    if @vertical
      spaceForOtherBar = if @horizontal then parseInt(@hTrack.css('height').replace('px', '')) else 0
      @vTrack.css( top: @navUpHeight, bottom: @navDownHeight + spaceForOtherBar )
      @vTrackHeight = parseInt(@vTrack.css('height').replace('px', ''))
      @down.css( bottom: spaceForOtherBar )
    if @horizontal
      spaceForOtherBar = if @vertical then parseInt(@vTrack.css('width').replace('px', '')) else 0
      @hTrack.css( left: @navLeftWidth, right: @navRightWidth + spaceForOtherBar )
      @hTrackWidth = parseInt(@hTrack.css('width').replace('px', ''))
      @right.css( right: spaceForOtherBar )

  contentCSSTop: =>
    parseInt(@content.css('top').replace('px', ''))
  minContentCSSTop: =>
    @viewportHeight - @contentHeight
  maxContentCSSTop: =>
    return 0

  contentCSSLeft: =>
    parseInt(@content.css('left').replace('px', ''))
  minContentCSSLeft: =>
    @viewportWidth - @contentWidth
  maxContentCSSLeft: =>
    return 0

  updateDragSizes: =>
    if @vertical
      @vDragHeight = Math.floor( @vTrackHeight * @viewportHeight / @contentHeight )
      @vDragHeight = @MINIMUM_DRAG_SIZE  if @vDragHeight < @MINIMUM_DRAG_SIZE
      @vDrag.css( height: @vDragHeight )
    if @horizontal
      @hDragWidth = Math.floor( @hTrackWidth * @viewportWidth / @contentWidth )
      @hDragWidth = @MINIMUM_DRAG_SIZE  if @hDragWidth < @MINIMUM_DRAG_SIZE
      @hDrag.css( width: @hDragWidth )

  update: =>
    if @vertical
      @vDragCSSTop = Math.abs(Math.floor(@vTrackHeight * @contentCSSTop() / @contentHeight))
      @vDragCSSTop = @vTrackHeight - @vDragHeight  if (@vDragCSSTop + @vDragHeight) > @vTrackHeight
      @vDrag.css( top : @vDragCSSTop )
      @up.add(@down).removeClass @DISABLED_CLASS
      @up.addClass(@DISABLED_CLASS)  if @vDragCSSTop is 0
      @down.addClass(@DISABLED_CLASS)  if (@vDragCSSTop + @vDragHeight) is @vTrackHeight
    if @horizontal
      @hDragCSSLeft = Math.abs(Math.floor(@hTrackWidth * @contentCSSLeft() / @contentWidth))
      @hDragCSSLeft = @hTrackWidth - @hDragWidth  if (@hDragCSSLeft + @hDragWidth) > @hTrackWidth
      @hDrag.css( left : @hDragCSSLeft )
      @left.add(@right).removeClass @DISABLED_CLASS
      @left.addClass(@DISABLED_CLASS)  if @hDragCSSLeft is 0
      @right.addClass(@DISABLED_CLASS)  if (@hDragCSSLeft + @hDragWidth) is @hTrackWidth

  startUpdating: =>
    @timer = setInterval(=>
      @update()
    , 10)

  stopUpdating: =>
    clearInterval(@timer)
    @update()

  scrollVertical: (offset) =>
    initialOffset = @contentCSSTop()
    targetOffset = initialOffset + offset
    targetOffset = @minContentCSSTop()  if targetOffset < @minContentCSSTop()
    targetOffset = @maxContentCSSTop()  if targetOffset > @maxContentCSSTop()
    speed = Math.abs(@SCROLL_SPEED * (initialOffset - targetOffset) / @viewportHeight)
    @startUpdating()
    @content.stop(true, false).animate
      top: targetOffset,
      speed, =>
        @stopUpdating()

  scrollHorizontal: (offset) =>
    initialOffset = @contentCSSLeft()
    targetOffset = initialOffset + offset
    targetOffset = @minContentCSSLeft()  if targetOffset < @minContentCSSLeft()
    targetOffset = @maxContentCSSLeft()  if targetOffset > @maxContentCSSLeft()
    speed = Math.abs(@SCROLL_SPEED * (initialOffset - targetOffset) / @viewportWidth)
    @startUpdating()
    @content.stop(true, false).animate
      left: targetOffset,
      speed, =>
        @stopUpdating()

  disableSelecting: =>
    window.getSelection().empty()  if BrowserUtils.browser() is 'Chrome'    # Unless cleared selection, Chrome will start drag & drop...
    $('body').css( 'user-select': 'none', 'moz-user-select': 'none' )
    @viewport.find('*').andSelf().attr('unselectable', 'on')

  enableSelecting: =>
    $('body').css( 'user-select': '', 'moz-user-select': '' )    # Disabling/enabling selection on body, since Chrome likes to keep selecting when mouse button is pressed
    @viewport.find('*').andSelf().removeAttr('unselectable')

  startVerticalDragging: (startpointY) =>
    initialDragCSSTop = @vDragCSSTop
    @disableSelecting()
    @startUpdating()
    $('body').on 'mousemove.actionable.scroll_bar.vertical_drag', (event) =>
      @vDragCSSTop = initialDragCSSTop + event.pageY - startpointY
      @vDragCSSTop = 0  if @vDragCSSTop < 0
      @vDragCSSTop = @vTrackHeight - @vDragHeight  if (@vDragCSSTop + @vDragHeight) > @vTrackHeight
      @vDrag.css( top: @vDragCSSTop )
      @content.css( top: Math.floor((@vDragCSSTop * @contentHeight / @vTrackHeight * (-1))) )

  startHorizontalDragging: (startpointX) =>
    initialDragCSSLeft = @hDragCSSLeft
    @disableSelecting()
    @startUpdating()
    $('body').on 'mousemove.actionable.scroll_bar.horizontal_drag', (event) =>
      @hDragCSSLeft = initialDragCSSLeft + event.pageX - startpointX
      @hDragCSSLeft = 0  if @hDragCSSLeft < 0
      @hDragCSSLeft = @hTrackWidth - @hDragWidth  if (@hDragCSSLeft + @hDragWidth) > @hTrackWidth
      @hDrag.css( left: @hDragCSSLeft )
      @content.css( left: Math.floor((@hDragCSSLeft * @contentWidth / @hTrackWidth * (-1))) )

  stopDragging: (event) =>
    @enableSelecting()
    @stopUpdating()
    $('body').unbind 'mouseup.actionable.scroll_bar.drag'
    $('body').unbind 'mousemove.actionable.scroll_bar.vertical_drag'
    $('body').unbind 'mousemove.actionable.scroll_bar.horizontal_drag'



  constructor: (@element) ->
    @viewport = $(@element)
    @viewport.data('scroll_bar_object', this)

    @MINIMUM_DRAG_SIZE = 12
    @DISABLED_CLASS = 'disabled'
    @MOUSEWHEEL_STEP = 100
    @SCROLL_SPEED = 250

    @paddingFix = Utils.initRawDataAttr @viewport, 'padding_fix', Constants.INTEGER_NOT_NEGATIVE, 0

    @initialize()
    @updateDragSizes()
    @update()

    if @vertical

      @up.on 'click.actionable.scroll_bar', =>
        @scrollVertical( @viewportHeight )

      @down.on 'click.actionable.scroll_bar', =>
        @scrollVertical( -@viewportHeight )

      @vDrag.on 'mousedown.actionable.scroll_bar', (event) =>
        $('body').on 'mouseup.actionable.scroll_bar.drag', =>
          @stopDragging()
        @startVerticalDragging(event.pageY)

      @vTrack.on 'click.actionable.scroll_bar', (event) =>
        if @vTrack.filter($(event.target)).length is 1
          if event.pageY - @vTrack.offset().top < @vDragCSSTop then @up.trigger('click') else @down.trigger('click')

      @viewport.on 'mousewheel.actionable.scroll_bar', (event, delta) =>
        return true  if delta is -1 and @contentCSSTop() is @minContentCSSTop()
        return true  if delta is 1  and @contentCSSTop() is @maxContentCSSTop()
        @scrollVertical( delta * @MOUSEWHEEL_STEP )
        return false

    if @horizontal

      @left.on 'click.actionable.scroll_bar', =>
        @scrollHorizontal( @viewportWidth )

      @right.on 'click.actionable.scroll_bar', =>
        @scrollHorizontal( -@viewportWidth )

      @hDrag.on 'mousedown.actionable.scroll_bar', (event) =>
        $('body').on 'mouseup.actionable.scroll_bar.drag', =>
          @stopDragging()
        @startHorizontalDragging(event.pageX)

      @hTrack.on 'click.actionable.scroll_bar', (event) =>
        if @hTrack.filter($(event.target)).length is 1
          if event.pageX - @hTrack.offset().left < @hDragCSSLeft then @left.trigger('click') else @right.trigger('click')



$ ->

# touch support
# testy
# dokumentacja


  $.fn.scrollBar = ->
    $(this).filter("[data-widget~='scroll_bar']").first().data('scroll_bar_object')


