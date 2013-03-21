class @Radio

  isSelected: =>
    if @input.attr('checked') then true else false

  set: (selected) =>
    if selected in [true, 1, 'selected']
      @input.attr('checked', true)
      @wrapper.addClass @SELECTED_CLASS
    if selected in [false, 0, 'deselected']
      @input.attr('checked', false)
      @wrapper.removeClass @SELECTED_CLASS

  select: =>
    @deselectGroup()
    @set(true)

  deselect:  =>
    @set(false)

  deselectGroup: =>
    radioWrappersInGroup = @input.closest('form').find("[name='" + @input.attr('name') + "']").closest('.radio')
    radioWrappersInGroup.each (index, element) ->
      $(element).data('radio_object').deselect()

  isDisabled: =>
    if @input.attr('disabled') then true else false

  enable: =>
    @input.attr('disabled', false)
    @wrapper.removeClass 'disabled'

  disable: =>
    @input.attr('disabled', true)
    @wrapper.addClass 'disabled'

  constructor: (@element) ->

    @WRAPPER_CLASS = 'radio'
    @SELECTED_CLASS = 'selected'
    @HIDDEN_CLASS = 'pushed_back'

    @input = $(@element)
    @input.addClass(@HIDDEN_CLASS).wrap("<div class='" + @WRAPPER_CLASS + " tabindex='-1'/>")

    @wrapper = @input.parent()
    @wrapper.data('radio_object', this)

    @select()  if @isSelected()     # Sets appropriate states on init
    @disable()  if @isDisabled()    # Sets appropriate states on init

    @wrapper.on 'click.actionable.radio', =>
      unless @isDisabled() or @isSelected()
        @select()

    @input.on 'change.actionable.radio', =>
      @select()  if @isSelected()    # This provides support for labels



$ ->

  $.fn.radio = ->
    $(this).filter('.radio').first().data('radio_object')


