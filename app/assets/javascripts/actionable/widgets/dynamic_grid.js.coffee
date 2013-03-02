class @DynamicGrid

  getAvailableColumnsCount: =>
    @dynamicGridWidth = @dynamicGrid.innerWidth()
    @columnsCount = ( (@dynamicGridWidth + @horizontalSpacing) - (@dynamicGridWidth + @horizontalSpacing) % (@blockWidth + @horizontalSpacing) ) / (@blockWidth + @horizontalSpacing)
    @columnsCount = Math.min(@columnsCount, @maxColumns)

  getAlignmentOffset: =>
    freeHorizontalSpace = @dynamicGridWidth - (@columnsCount * @blockWidth) - ( (@columnsCount-1) * @horizontalSpacing)
    switch @alignment
      when 'left'
        @alignmentOffset = 0
      when 'center'
        @alignmentOffset = Math.floor(freeHorizontalSpace / 2)
      when 'right'
        @alignmentOffset = freeHorizontalSpace

  getLowestColumnNumber: =>
    lowest = 1
    for i in [1..@columnsCount]
      lowest = i  if @columnHeights[i] < @columnHeights[lowest]
    return lowest

  getHighestColumnNumber: =>
    highest = 1
    for i in [1..@columnsCount]
      highest = i  if @columnHeights[i] > @columnHeights[highest]
    return highest

  rearrange: =>
    if @dynamicGrid.filter(':visible').length > 0
      unless @isDisabled()
        @getAvailableColumnsCount()
        @columnHeights[i] = 0  for i in [1..@columnsCount]
        @getAlignmentOffset()
        for i in [1..@blocks.length]
          targetedColumn = @getLowestColumnNumber()
          @blocks.eq(i-1).css
            top: @columnHeights[targetedColumn]
            left: @alignmentOffset + (targetedColumn - 1) * (@blockWidth + @horizontalSpacing)
          @columnHeights[targetedColumn] = @columnHeights[targetedColumn] + @blocks.eq(i-1).outerHeight() + @verticalSpacing
        @dynamicGrid.css(height: (@columnHeights[@getHighestColumnNumber()] - @verticalSpacing) + 'px')

  isDisabled: =>
    if @dynamicGrid.hasClass('disabled') then true else false

  enable: =>
    @dynamicGrid.removeClass('disabled')

  disable: =>
    @dynamicGrid.addClass('disabled')



  constructor: (@element) ->
    @dynamicGrid = $(@element)
    @dynamicGrid.data('dynamic_grid_object', this)

    @blocks = Utils.initRawDataAttr @dynamicGrid, 'blocks', Constants.STRING, '> li'
    @blocks = @dynamicGrid.find(@blocks)
    @blockWidth = Utils.initRawDataAttr @dynamicGrid, 'block_width', Constants.INTEGER_POSITIVE, Constants.EMPTY
    @blockWidth = @blocks.first().outerWidth()  if @blockWidth is Constants.EMPTY
    @minColumns = Utils.initRawDataAttr @dynamicGrid, 'min_columns', Constants.INTEGER_POSITIVE, '1'
    @maxColumns = Utils.initRawDataAttr @dynamicGrid, 'max_columns', Constants.INTEGER_NOT_NEGATIVE, '2048'
    @horizontalSpacing = Utils.initRawDataAttr @dynamicGrid, 'horizontal_spacing', Constants.INTEGER_NOT_NEGATIVE, '10'
    @verticalSpacing = Utils.initRawDataAttr @dynamicGrid, 'vertical_spacing', Constants.INTEGER_NOT_NEGATIVE, '10'
    @alignment = Utils.initRawDataAttr @dynamicGrid, 'alignment', Constants.STRING, 'center'
    @throttle = Utils.initRawDataAttr @dynamicGrid, 'throttle', Constants.INTEGER_NOT_NEGATIVE, '50'

    @timer = null
    @columnHeights = []

    $(window).on 'resize.actionable.dynamic_grid', =>
      clearTimeout(@timer)
      @timer = setTimeout( =>
        @rearrange()
      , @throttle)

    @rearrange()



$ ->



  $.fn.dynamicGrid = ->
    $(this).filter("[data-widget~='dynamic_grid']").first().data('dynamic_grid_object')


