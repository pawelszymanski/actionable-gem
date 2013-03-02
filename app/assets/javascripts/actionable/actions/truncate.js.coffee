class @Truncate

  linesCount = (element) ->
    Math.ceil( element.height() / element.css('line-height').toString().replace('px', '') )

  charactersCount = (element) ->
    element.text().length

  removeLastWord = (element) ->
    element.text element.text().replace(/[.,!?:;"'()-_]*\s+\S*$/, '')

  removeEllipsis = (element, ellipsis) ->
    element.text element.text().slice(0, element.text().lastIndexOf(ellipsis))

  appendLineWithEllipsis = (element, ellipsis, breakWord) ->
    initialLines = linesCount(element)
    element.text element.text() + ellipsis
    while linesCount(element) > initialLines
      if breakWord is true
        element.text element.text().slice(0, (element.text().lastIndexOf(ellipsis) - 1)) + ellipsis
      else
        removeEllipsis(element, ellipsis)
        removeLastWord(element)
        element.text element.text() + ellipsis

  constructor: (element) ->
    element.text $.trim element.text()
    if element.css('line-height').toString().indexOf('px') is -1
      Utils.debugMessage "element\'s CSS 'line-height' property is required, please set it to 'px' or 'em' value" + ", inspect the following:", $(this)
      return
    lines = Utils.initRawDataAttr element, 'lines', Constants.INTEGER_POSITIVE, Constants.EMPTY
    characters = Utils.initRawDataAttr element, 'characters', Constants.INTEGER_POSITIVE, Constants.EMPTY
    if lines is Constants.EMPTY and characters is Constants.EMPTY
      Utils.debugMessage "'data-lines' or 'data-characters' is required, but both are " + Constants.constToHumanString(Constants.EMPTY) + ", inspect the following:", $(this)
      return
    ellipsis = Utils.initRawDataAttr element, 'ellipsis', Constants.STRING, Constants.EMPTY
    breakWord = Utils.initRawDataAttr element, 'break_word', Constants.BOOLEAN, false

    if (element.filter(':visible').length is 0) and (lines isnt Constants.EMPTY)
      Utils.debugMessage "Truncation to number of lines can't be run on hidden elements, inspect the following:", $(element)
      return

    if lines isnt Constants.EMPTY and linesCount(element) > lines
      removeLastWord(element)  while linesCount(element) > lines
      appendLineWithEllipsis(element, ellipsis, breakWord)  if ellipsis isnt Constants.EMPTY

    if characters isnt Constants.EMPTY and charactersCount(element) > characters
      if breakWord is true
        element.text element.text().substr(0, characters) + ellipsis
      else
        removeLastWord(element)  while charactersCount(element) > characters
        element.text element.text() + ellipsis


