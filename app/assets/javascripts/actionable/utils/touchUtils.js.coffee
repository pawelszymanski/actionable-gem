class TouchUtils

  constructor: ->

    # Only those three touch events are platform-compatibile, rely only on them
    tStart = if window.ontouchstart is undefined then false else true
    tMove = if window.ontouchmove is undefined then false else true
    tEnd = if window.ontouchend is undefined then false else true
    @isTouchable = if tStart and tMove and tEnd then true else false

    @eventDown = if @isTouchable then 'touchstart' else 'mousedown'
    @eventMove = if @isTouchable then 'touchmove'  else 'mousemove'
    @eventUp =   if @isTouchable then 'touchend'   else 'mouseup'



@TouchUtils = new TouchUtils


