class @Dropdown

  @collapseAllDropdowns: ->
    $("body .expanded[data-widget~='dropdown']").each (index, element) ->
      $(element).data('dropdown_object').collapse()

  sortByValue: =>
    values = []
    @optionsList.each (i, e) ->
      values.push($(this).data('value'))
    values.sort()
    for i in [0..values.length-1]
      @getLiElemByValue(values[i]).appendTo @optionsBox

  sortByText: =>
    texts = []
    @optionsList.each (i, e) ->
      texts.push($.trim($(this).text()))
    texts.sort()
    for i in [0..texts.length-1]
      @getLiElemByText(texts[i]).appendTo @optionsBox

  getLiElemByText: (text) =>
    result = null
    @optionsList.each (i, e) ->
      result = $(this)  if $.trim($(this).text()) is text
    return result

  getLiElemByValue: (value) =>
    @optionsList.filter("[data-value='" + value + "']").eq(0)

  getHTMLByValue: (value) =>
    $.trim @getLiElemByValue(value).html()

  getTextByValue: (value) ->
    $.trim @getLiElemByValue(value).text()

  setValue: (value) =>
    @input.val value
    @value.html @getHTMLByValue(value)
    @optionsList.removeClass 'active'
    @getLiElemByValue(value).addClass 'active'

  getValue: ->
    @input.val().toString()

  getText: ->
    $.trim @value.text()

  appendOption: (html, value) ->
    @optionsBox.append('<li data-value=' + value + '></li>')
    newLi = @optionsBox.find('li').last()
    newLi.html html
    newLi.on 'click.actionable.dropdown', ->
      @onOptionsClicked(newLi)
    @optionsList = @optionsList.add(newLi)

  removeOption: (value) ->
    @setValue ''  if @getValue() is value.toString()
    @getLiElemByValue(value).remove()
    @optionsList = @dropdown.find 'ul.options li'

  animate: (animationMode) =>
    @optionsBox.stop true, true
    switch animationMode
      when 'expand'
        if Helpers.isEnabled @dropdown
          if @animation is 'slide'
            @optionsBox.slideDown @animationSpeed
          else if @animation is 'fade'
            @optionsBox.fadeIn @animationSpeed
          else @optionsBox.show()
          @dropdown.addClass 'expanded'
      when 'collapse'
        if @animation is 'slide'
          @optionsBox.slideUp @animationSpeed
        else if @animation is 'fade'
          @optionsBox.fadeOut @animationSpeed
        else @optionsBox.hide()
        @dropdown.removeClass 'expanded'

  expand: =>
    Dropdown.collapseAllDropdowns()
    @animate 'expand'

  collapse: =>
    @animate 'collapse'

  toggle: ->
    if @dropdown.hasClass 'expanded' then @collapse() else @expand()

  onOptionsClicked: (element) ->
    @setValue $(element).data('value')
    @collapse()

  constructor: (@element) ->
    @dropdown = $(@element)
    @dropdown.data('dropdown_object', this)

    @animation = Utils.initRawDataAttr @dropdown, 'animation', Constants.STRING, 'instant'
    @animationSpeed = Utils.initRawDataAttr @dropdown, 'animation_speed', Constants.INTEGER_POSITIVE, 200
    @input = @dropdown.find 'input'
    @value = @dropdown.find '.value'
    @clicker = @dropdown.find '.clicker'
    @optionsBox = @dropdown.find 'ul.options'
    @optionsBox.css 'top', @value.outerHeight()
    @optionsList = @dropdown.find 'ul.options li'
    @setValue @getValue()

    @value.add(@clicker).on 'click.actionable.dropdown', (event) =>
      event.stopPropagation()
      @toggle()

    @optionsList.on 'click.actionable.dropdown', (event) =>
      @onOptionsClicked event.currentTarget



$ ->

  $.fn.dropdown = ->
    $(this).filter("[data-widget~='dropdown']").first().data('dropdown_object')

  $('body').on 'click.actionable.dropdown', (event) ->
    Dropdown.collapseAllDropdowns()


