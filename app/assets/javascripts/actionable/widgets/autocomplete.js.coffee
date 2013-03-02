class @Autocomplete

  showList: =>
    @list.show()
    @isListShown = true

  hideList: =>
    @list.hide()
    @isListShown = false

  resetList: =>
    @list.find('li').remove()
    @highlightedListItem = null

  setHints: (newHints) =>
    @hints = newHints

  findMatches: =>
    @matches = []
    for i in [0..@hints.length-1]
      indexOf = @hints[i].caseExtendedIndexOf(@usersText, @caseSensitive)
      @matches.push @hints[i]  if indexOf > -1

  sortMatches: =>
    for i in [0..@matches.length-1]
      position = (@matches[i].caseExtendedIndexOf(@usersText, @caseSensitive)).toString()
      @matches[i] = (position + @matches[i]).addLeadingZeros(8-position.length)
    @matches.sort()
    @matches[i] = @matches[i].slice(8)  for i in [0..@matches.length-1]

  createListElems: =>
    @htmledMatches = []
    for i in [0..@matches.length-1]
      @htmledMatches.push ('<li>' + @matches[i].replace(@usersText, '<mark>' + @usersText + '</mark>') + '</li>')
    for i in [0..Math.min(@matches.length, @maxResults-1)]
      $(@htmledMatches[i]).appendTo(@list)
    @listElems = @list.find('li')
    @listElems.on 'mousedown.actionable.autocomplete', (event) =>    # Unfortunatly 'click' event makes list disappear before clicked, because clicking triggers blur first...
      @useHintText($(event.currentTarget).text())

  updateList: =>
    @usersText = @input.val()
    @hideList()
    @resetList()
    unless @usersText is '' or @hints.length is 0
      @findMatches()
      unless @matches.length is 0
        @sortMatches()  if @sorting
        @createListElems()
        unless (@matches.length is 1 and @matches[0] is @usersText)
          @showList()

  restoreUsersText: =>
    @listElems.removeClass @HIGHLIGHTED_CLASS
    @highlightedListItem = null
    @input.val @usersText

  highlightListElem: (eq) =>
    @listElems.removeClass @HIGHLIGHTED_CLASS
    $(@listElems[eq]).addClass @HIGHLIGHTED_CLASS
    @highlightedListItem = eq
    @input.val $(@listElems[eq]).text()

  highlightPrev: =>
    switch @highlightedListItem
      when null
        @highlightListElem(@listElems.length-1)
      when 0
        @restoreUsersText()
      else
        @highlightListElem(@highlightedListItem-1)

  highlightNext: =>
    switch @highlightedListItem
      when null
        @highlightListElem(0)
      when @listElems.length-1
        @restoreUsersText()
      else
        @highlightListElem(@highlightedListItem+1)

  useHintText: (newText) =>
    @input.val newText
    @hideList()



  constructor: (@element) ->
    @HIGHLIGHTED_CLASS = 'active'

    @input = $(@element)
    @input.data('autocomplete_object', this)

    @list = Utils.initRawDataAttr @input, 'list', Constants.STRING, Constants.EMPTY
    @list = $(@list)
    unless $(@list).length is 1
      Utils.debugMessage "'data-list' is required to point to unique DOM element, inspect the following:", $(this)
      return

    @hints = Utils.initRawDataAttr @input, 'hints', Constants.STRING, Constants.EMPTY
    if @hints is Constants.EMPTY then @hints = [] else @hints = JSON.parse(@hints)

    @sorting = Utils.initRawDataAttr @input, 'sorting', Constants.BOOLEAN, true
    @caseSensitive = Utils.initRawDataAttr @input, 'case_sensitive', Constants.BOOLEAN, false
    @minCharacters = Utils.initRawDataAttr @input, 'min_characters', Constants.INTEGER_POSITIVE, 1
    @maxResults = Utils.initRawDataAttr @input, 'max_results', Constants.INTEGER_POSITIVE, 15

    @hideList()
    @resetList()

    @input.on 'focus.actionable.autocomplete', =>
      @updateList()

    @input.on 'blur.actionable.autocomplete', =>
      @hideList()

    @input.on 'keydown.actionable.autocomplete', (event) =>
      event.preventDefault()  if @isListShown and KeyboardUtils.decodeKeyCode(event.keyCode) in ['Arrow Up', 'Arrow Down']    # Stops Opera from scrolling when broswing list

    @input.on 'keypress.actionable.autocomplete', (event) =>
      return false  if @isListShown and KeyboardUtils.decodeKeyCode(event.keyCode) is 'Enter'    # Prevents form submition when selecting hint with Enter key

    @input.on 'keyup.actionable.autocomplete', (event) =>
      keyName = KeyboardUtils.decodeKeyCode(event.keyCode)
      if keyName in ['Escape', 'Enter', 'Arrow Up', 'Arrow Down']
        if @isListShown then switch keyName
          when 'Escape'
            @restoreUsersText()
            @hideList()
          when 'Enter'
            @useHintText $(@listElems[@highlightedListItem]).text()  unless @highlightedListItem is null
            @hideList()
          when 'Arrow Up'
            @highlightPrev()
          when 'Arrow Down'
            @highlightNext()
      else
        if @input.val().length >= @minCharacters then @updateList() else @hideList()



$ ->

  $.fn.autocomplete = ->
      $(this).filter("[data-widget~='autocomplete']").first().data('autocomplete_object')


