class @Pushable

  constructor: (element) ->

    element.on 'mousedown.actionable.pushable', ->
      element.addClass 'pushed'  if Helpers.isEnabled element

    element.on 'mouseup.actionable.pushable', ->
      element.removeClass 'pushed'  if Helpers.isEnabled element

    element.on 'mouseleave.actionable.pushable', ->
      element.removeClass 'pushed'


