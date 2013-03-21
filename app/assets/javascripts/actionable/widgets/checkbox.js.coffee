class @Checkbox

  isChecked: =>
    if @input.attr('checked') then true else false

  set: (checked) =>
    if checked in [true, 1, 'checked']
      @input.attr('checked', true)
      @wrapper.addClass @CHECKED_CLASS
    if checked in [false, 0, 'unchecked']
      @input.attr('checked', false)
      @wrapper.removeClass @CHECKED_CLASS

  check:  =>
    @set(true)

  uncheck:  =>
    @set(false)

  toggle: =>
    if @isChecked() then @set(false) else @set(true)

  isDisabled: =>
    if @input.attr('disabled') then true else false

  enable: =>
    @input.attr('disabled', false)
    @wrapper.removeClass 'disabled'

  disable: =>
    @input.attr('disabled', true)
    @wrapper.addClass 'disabled'

  constructor: (@element) ->

    @WRAPPER_CLASS = 'checkbox'
    @CHECKED_CLASS = 'checked'
    @HIDDEN_CLASS = 'pushed_back'

    @input = $(@element)
    @input.addClass(@HIDDEN_CLASS).wrap("<div class='" + @WRAPPER_CLASS + "'/>")

    @wrapper = @input.parent()
    @wrapper.data('checkbox_object', this)

    @check()  if @isChecked()      # Sets appropriate states on init
    @disable()  if @isDisabled()   # Sets appropriate states on init

    @wrapper.on 'click.actionable.checkbox', =>
      unless @isDisabled()
        @toggle()

    @wrapper.on 'focusin.actionable.checkbox', =>
      @wrapper.focus()



$ ->

  $.fn.checkbox = ->
    $(this).filter('.checkbox').first().data('checkbox_object')


