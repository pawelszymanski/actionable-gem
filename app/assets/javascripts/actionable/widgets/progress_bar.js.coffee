class @ProgressBar

  getValue: =>
    @value

  setValue: (newValue) =>
    @value = newValue
    @value = 0  if @value < 0
    @value = @maxValue  if @value > @maxValue
    @progressBar.data('value', @value)
    @animate()

  increase: (step) =>
    step = step?| 1
    @setValue(@value + step)

  decrease: (step) =>
    step = step?| 1
    @setValue(@value - step)

  animate: =>
    unless @isDisabled()
      destination = 100 * @value / @maxValue + '%'
      @bar.stop(true, false).animate(width: destination, @animationSpeed)   if @axis.toUpperCase() is 'X'
      @bar.stop(true, false).animate(height: destination, @animationSpeed)  if @axis.toUpperCase() is 'Y'

  isDisabled: =>
    if @progressBar.hasClass('disabled') then true else false

  enable: =>
    @progressBar.removeClass('disabled')

  disable: =>
    @progressBar.addClass('disabled')



  constructor: (@element) ->
    @progressBar = $(@element)
    @progressBar.data('progress_bar_object', this)

    @bar = Utils.initRawDataAttr @progressBar, 'bar', Constants.STRING, '> .bar'
    @bar = @progressBar.find(@bar).eq(0)
    @value = Utils.initRawDataAttr @progressBar, 'value', Constants.INTEGER_NOT_NEGATIVE, 0
    @maxValue = Utils.initRawDataAttr @progressBar, 'max_value', Constants.INTEGER_POSITIVE, 100
    @axis = Utils.initRawDataAttr @progressBar, 'axis', Constants.STRING, 'x'
    @animationSpeed = Utils.initRawDataAttr @progressBar, 'animation_speed', Constants.INTEGER_POSITIVE, 0

    @setValue(@value)



$ ->



  $.fn.progressBar = ->
    $(this).filter("[data-widget~='progress_bar']").first().data('progress_bar_object')


