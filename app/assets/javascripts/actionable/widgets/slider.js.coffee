class @Slider

  setActiveSlide: (slideNumber) =>
    @navigationButtons.add(@slides).removeClass 'active'
    @slides.eq(slideNumber-1).add(@navigationButtons.eq(slideNumber-1)).addClass 'active'

  getCurrentSlide: =>
    @slides.filter('.active').data 'slide'

  getSlidesWrapperOffset: =>
    Math.abs(@slidesWrapper.css('left').replace('px', ''))

  isSlidesWrapperAtStart: =>
    result = if @getSlidesWrapperOffset() is 0 then true else false

  isSlidesWrapperAtEnd: =>
    result = if @getSlidesWrapperOffset() is ((@numberOfSlides-1)*@slideWidth) then true else false

  prependSlidesWrapperWithLastSlide: =>
    @slidesWrapper.prepend(@slidesWrapper.children()[@numberOfSlides-1])
    @slidesWrapper.css('left', '-=' + @slideWidth)

  appendSlidesWrapperWithFirstSlide: =>
    @slidesWrapper.append(@slidesWrapper.children()[0])
    @slidesWrapper.css('left', '+=' + @slideWidth)

  slideBy: (slidesOffset) =>
    return  if slidesOffset is 0
    @slidesWrapper.stop true, true
    newSlideNumber = (@getCurrentSlide() + slidesOffset + @numberOfSlides) % @numberOfSlides
    newSlideNumber = @numberOfSlides  if newSlideNumber is 0
    @setActiveSlide(newSlideNumber)
    if @rewind
      @slidesWrapper.animate(left: (-(newSlideNumber-1) * @slideWidth), @slideSpeed)
    else for slide in [1..Math.abs(slidesOffset)]
      if slidesOffset < 0
        @prependSlidesWrapperWithLastSlide()  if @isSlidesWrapperAtStart()
        @slidesWrapper.animate(left: '-=' + (-1 * @slideWidth), (@slideSpeed/Math.abs(slidesOffset)), =>
          @prependSlidesWrapperWithLastSlide())
      if slidesOffset > 0
        @appendSlidesWrapperWithFirstSlide()  if @isSlidesWrapperAtEnd()
        @slidesWrapper.animate(left: '-=' + (@slideWidth), (@slideSpeed/slidesOffset), =>
          @appendSlidesWrapperWithFirstSlide())

  slideTo: (slideNumber) =>
    @slideBy(slideNumber - @getCurrentSlide())

  autoSlide: =>
    @slideBy(+1)

  start: =>
    clearInterval(@timer)    # This removes multiple scrolls when dev used start() few times without using stop() meantime
    @timer = setInterval(=>
      @autoSlide()
    , @interval)

  stop: =>
    clearInterval(@timer)

  isMeetingAutoSlideRequirements: =>
    if (@interval isnt 0) and (@numberOfSlides > 1) then return true else return false

  constructor: (element) ->
    @slider = $(element)
    @slider.data('slider_object', this)

    @interval = Utils.initRawDataAttr @slider, 'interval', Constants.INTEGER_NOT_NEGATIVE, '0'
    @slideSpeed = Utils.initRawDataAttr @slider, 'slide_speed', Constants.INTEGER_POSITIVE, '400'
    @startAt = Utils.initRawDataAttr @slider, 'start_at', Constants.INTEGER_POSITIVE, '1'
    @rewind = Utils.initRawDataAttr @slider, 'rewind', Constants.BOOLEAN, true

    @timer = null

    @viewport = @slider.find('.viewport')
    @slides = @slider.find('.slide')
    @previous = @slider.find('.previous')
    @next = @slider.find('.next')
    @navigationButtons = @slider.find('ul.navigation li')

    @slideWidth = @viewport.innerWidth()
    @numberOfSlides = @slides.size()

    @slides.each (index, element) =>
      $(element).attr('data-slide', index + 1)
    @navigationButtons.each (index, element) =>
      $(element).attr('data-slide', index + 1)

    @slides.css('width', @slideWidth + 'px')
    @slides.wrapAll("<div class='slides_wrapper'></div>")
    @slidesWrapper = @slider.find('.slides_wrapper')
    @slidesWrapper.css
      'width': (@numberOfSlides * @slideWidth) + 'px'
      'left': -(@startAt-1) * @slideWidth
    @setActiveSlide(@startAt)

    @slider.on 'mouseenter.actionable.slider', =>
      @stop()

    @slider.on 'mouseleave.actionable.slider', =>
      @start()  if @isMeetingAutoSlideRequirements()

    @previous.on 'click.actionable.slider', =>
      @slideBy(-1)

    @next.on 'click.actionable.slider', =>
      @slideBy(+1)

    @navigationButtons.on 'click.actionable.slider', (event) =>
      @slideBy($(event.currentTarget).data('slide') - @getCurrentSlide())

    @start()  if @isMeetingAutoSlideRequirements()



$ ->

  $.fn.slider = ->
    $(this).filter("[data-widget~='slider']").first().data('slider_object')


