class @Tooltip

  @enableTooltipsIn: (selector) ->
    $(selector).find("[data-widget~='tooltip']").each (index, element) ->
      $(element).data('tooltip_object').disabled = false

  @disableTooltipsIn: (selector) ->
    $(selector).find("[data-widget~='tooltip']").each (index, element) ->
      $(element).data('tooltip_object').disabled = true

  createTooltipElem: =>
    $('body').append("<div id='#{@id}'></div>")
    @tooltipElem = $("##{@id}")
    @tooltipElem.css(position: 'fixed', 'z-index': '100')

  calcTooltipPosition: =>
    left = @pointerCoords.x - ScreenUtils.documentScrollLeft()
    top = @pointerCoords.y - ScreenUtils.documentScrollTop() + @OFFSET_Y_BOTTOM
    if top + @tooltipElem.outerHeight() > $(window).height()    # Since tooltip do not overflow screen from right (it's how browsers render suprisingly), only concern is to adjusting vertical position of tooltip
      top = top - @OFFSET_Y_BOTTOM - @tooltipElem.outerHeight() - (@pointerCoords.y - @tooltip.offset().top) - @OFFSET_Y_TOP
    @tooltipElem.css(left: left + 'px', top:  top  + 'px')

  setText: (text) =>
    @text = text

  getText: =>
    @text

  show: =>
    @tooltipElem.attr('class', @klass)
    @tooltipElem.text @text
    @calcTooltipPosition()
    @tooltipElem.show()
    @showCoords = @pointerCoords

  hide: =>
    @tooltipElem.hide()

  constructor: (@element) ->
    @tooltip = $(@element)
    @tooltip.data('tooltip_object', this)

    @text = Utils.initRawDataAttr @tooltip, 'text', Constants.STRING, Constants.EMPTY
    @delay = Utils.initRawDataAttr @tooltip, 'delay', Constants.INTEGER_NOT_NEGATIVE, 600
    @id = Utils.initRawDataAttr @tooltip, 'id', Constants.STRING, 'tooltip'
    @klass = Utils.initRawDataAttr @tooltip, 'class', Constants.STRING, Constants.EMPTY

    if $("##{@id}").length is 1 then @tooltipElem = $("##{@id}") else @createTooltipElem()
    @timer = null
    @isDisplayed = false
    @wasDisplayed = false
    @disabled = false

    @OFFSET_Y_TOP = 10
    @OFFSET_Y_BOTTOM = 20

    @hide()

    @tooltip.on 'mousemove.actionable.tooltip', (event) =>
      @pointerCoords = { x: event.pageX, y: event.pageY }
      if @isDisplayed
        @hide()  if ((@pointerCoords.x - @showCoords.x) * (@pointerCoords.x - @showCoords.x) + (@pointerCoords.y - @showCoords.y) * (@pointerCoords.y - @showCoords.y)) > 36
      else
        unless @wasDisplayed or @disabled
          clearTimeout(@timer)
          @timer = setTimeout( =>
            unless @isDisplayed or @wasDisplayed
              @show()
              @isDisplayed = true
              @wasDisplayed = true
          , @delay)

    @tooltip.on 'mouseleave.actionable.tooltip', =>
      clearTimeout(@timer)
      @hide()
      @isDisplayed = false
      @wasDisplayed = false



$ ->



  $.fn.tooltip = ->
    $(this).filter("[data-widget~='tooltip']").first().data('tooltip_object')


