class BrowserUtils

  constructor: ->

    @OS_WINDOWS = 'Windows'
    @OS_MAC = 'MacOS'
    @OS_LINUX = 'Linux'
    @OS_IPAD = 'iPad'
    @OS_IPHONE = 'iPhone'
    @OS_ANDROID = 'Android'
    @OS_BLACKBERRY = 'Blackberry'
    @OS_SYMBIAN = 'Symbian'
    @OS_WINDOWS_CE = 'Windows CE'
    @OS_UNKNOWN = 'Unknown OS'

    @BROWSER_IE = 'Internet Explorer'
    @BROWSER_FIREFOX = 'Firefox'
    @BROWSER_CHROME = 'Chrome'
    @BROWSER_SAFARI = 'Safari'
    @BROWSER_OPERA = 'Opera'
    @BROWSER_UNKNOWN = 'Unknown browser'

    @appVersion = navigator.appVersion.toUpperCase()
    @userAgent = navigator.userAgent.toUpperCase()
    @platform = navigator.platform.toUpperCase()

  browser: =>
    return @BROWSER_IE       if @userAgent.indexOf("MSIE") isnt -1
    return @BROWSER_FIREFOX  if @userAgent.indexOf('FIREFOX') isnt -1
    return @BROWSER_CHROME   if @userAgent.indexOf("CHROME") isnt -1
    return @BROWSER_SAFARI   if @userAgent.indexOf('SAFARI') isnt -1
    return @BROWSER_OPERA    if @userAgent.indexOf('OPERA') isnt -1
    return @BROWSER_UNKNOWN

  OS: =>
    return @OS_WINDOWS     if @platform.indexOf("WIN") isnt -1
    return @OS_MAC         if @platform.indexOf('MAC') isnt -1
    return @OS_LINUX       if @platform.indexOf('LINUX') isnt -1
    return @OS_IPAD        if @platform.indexOf('IPAD') isnt -1
    return @OS_IPHONE      if @platform.indexOf('IPHONE') isnt -1
    return @OS_ANDROID     if @userAgent.indexOf('ANDROID') isnt -1
    return @OS_BLACKBERRY  if @userAgent.indexOf('BLACKBERRY') isnt -1
    return @OS_SYMBIAN     if ( (@userAgent.indexOf('SYMBIAN') isnt -1) or (@userAgent.indexOf('SERIES60') isnt -1) )
    return @OS_WINDOWS_CE  if @userAgent.indexOf('WINDOWS CE') isnt -1
    return @OS_UNKNOWN

  isHandheld: =>
    return true  if orientation?
    return false  if @OS() is @OS_WINDOWS or @OS() is @OS_MAC or @OS() is @OS_LINUX
    return true



@BrowserUtils = new BrowserUtils


