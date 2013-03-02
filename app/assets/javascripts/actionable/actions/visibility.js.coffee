class @Visibility

  setVisibility: (scope, action) =>
    @element[action]()  if BrowserUtils.OS().toUpperCase() is scope
    @element[action]()  if BrowserUtils.browser().toUpperCase() is scope

  constructor: (@element) ->
    show = Utils.initRawDataAttr @element, 'show', Constants.STRING, Constants.EMPTY
    hide = Utils.initRawDataAttr @element, 'hide', Constants.STRING, Constants.EMPTY
    if show is Constants.EMPTY and hide is Constants.EMPTY
      Utils.debugMessage "'data-show' or 'data-hide' is required, but both are " + Constants.constToHumanString(Constants.EMPTY) + ", inspect the following:", $(this)
      return

    @allShowScopes = show.split(/,/)
    for scope in @allShowScopes
      scope = $.trim scope.toUpperCase()
      @setVisibility(scope, 'show')  if scope isnt Constants.EMPTY

    @allHideScopes = hide.split(/,/)
    for scope in @allHideScopes
      scope = $.trim scope.toUpperCase()
      @setVisibility(scope, 'hide')  if scope isnt Constants.EMPTY


