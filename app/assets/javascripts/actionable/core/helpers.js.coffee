class Helpers

  isEnabled: (element) ->
    not $(element).hasClass 'disabled'



  Array::removeEmptyStrings = ->
    result = []
    while this.length > 0
      str = this.shift()
      result.push(str)  if str isnt ''
    return result

  Array::trimStrings = ->
    result = []
    while this.length > 0
      result.push( $.trim this.shift() )
    return result



  Array::intersect = (compared) ->
    result = []
    return result  if this.length is 0 or compared.length is 0
    for i in [0..this.length - 1]
      result.push(this[i])  if this[i] in compared
    return result.unduplicate()

  Array::detract = (subset) ->
    return this  if this.length is 0 or subset.length is 0
    result = []
    for i in [0..this.length - 1]
      result.push(this[i])  unless this[i] in subset
    return result



  Array::unduplicate = ->
    result = []
    while this.length > 0
      if this.length is 1
        result.push(this[0])
        break
      else
        unique = true
        for i in [1..this.length - 1]
          unique = false  if this[0] is this[i]
        result.push(this[0])  if unique
        this.shift()
    return result



  String::isMadeOfDigitsOnly = ->
    result = if parseFloat(this).toString().replace('.', '') is this.toString() then true else false

  String::addLeadingZeros = (amount) ->
    result = this
    if amount > 0
      result = '0' + result  for i in [0..amount-1]
    return result

  String::removeLeadingZeros = ->
    result = this
    result = result.slice(1, result.lenght)  while result[0] is '0'
    return result

  String::inject = (position, injection) ->
    return (injection + this)  if position is 0
    position = this.length+1  if position > this.length+1
    return this.substr(0, position) + injection + this.substr(position)

  String::caseExtendedIndexOf = (substring, caseSensitive) ->
    if caseSensitive then result = this.indexOf(substring) else result = this.toUpperCase().indexOf(substring.toUpperCase())
    return result



@Helpers = new Helpers



$.fn.isEnabled = ->
  not $(this).first().hasClass 'disabled'


