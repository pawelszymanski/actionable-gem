class @Datepicker

  daysInMonth = (year, month) ->                            # 1-indexed
    new Date(year, month, 0).getDate()

  dayOfWeekOfMonthsFirst = (year, month) ->                 # 1-indexed, starting from monday (1) till sunday (7)
    dayOfWeek = (new Date(year, month - 1, 1)).getDay()
    dayOfWeek = 7 if dayOfWeek is 0
    return dayOfWeek

  isStringADate: (string, format) =>
    if string?
      format = @format  unless format?
      switch format
        when 'EU' then  pattern = /^\d{2}-\d{2}-\d{4}$/
        when 'US' then  pattern = /^\d{2}-\d{2}-\d{4}$/
        when 'ISO' then pattern = /^\d{4}-\d{2}-\d{2}$/
      if pattern.test(string)
        split = string.split('-')
        switch format
          when 'EU'
            year =  +split[2]
            month = +split[1]
            day =   +split[0]
          when 'US'
            year =  +split[2]
            month = +split[0]
            day =   +split[1]
          when 'ISO'
            year =  +split[0]
            month = +split[1]
            day =   +split[2]
        return true  if month in [1..12] and day in [1..daysInMonth(year, month)]
    return false

  stringToDate: (string, format) =>
    format = @format  unless format?
    split = string.split('-')
    switch format
      when 'EU'
        year =  +split[2]
        month = +split[1]
        day =   +split[0]
      when 'US'
        year =  +split[2]
        month = +split[0]
        day =   +split[1]
      when 'ISO'
        year =  +split[0]
        month = +split[1]
        day =   +split[2]
    date = new Date year, month-1, day, 0, 0, 0, 0
    return date

  dateToString: (date, format) =>
    format = @format  unless format?
    year =  date.getFullYear().toString()
    month = (date.getMonth() + 1).toString()
    month = month.addLeadingZeros( 2 - month.length )
    day =   date.getDate().toString()
    day = day.addLeadingZeros( 2 - day.length )
    switch format
      when 'EU' then  string = day + '-' + month + '-' + year
      when 'US' then  string = month + '-' + day + '-' + year
      when 'ISO' then string = year + '-' + month + '-' + day
    return string

  setDate: (date) =>
    @selectedDate = date
    @update()

  getDate: =>
    return @selectedDate

  setHighlightedDate: (date) =>
    @initialHighlightedMonth = @highlightedMonth
    @highlightedDate = date
    if @highlightedDate?
      @highlightedDay = @highlightedDate.getDate()
      @highlightedMonth = @highlightedDate.getMonth() + 1
      @highlightedYear = @highlightedDate.getFullYear()
      @daysInHighlightedMonth = daysInMonth(@highlightedYear, @highlightedMonth)
      @dayOfWeekOfHighlitedMonthFirst = dayOfWeekOfMonthsFirst(@highlightedYear, @highlightedMonth)
      @previousMonthsDaysToDraw = @dayOfWeekOfHighlitedMonthFirst - 1
      @nextMonthsDaysToDraw = (42 - @previousMonthsDaysToDraw - @daysInHighlightedMonth) % 7
      if @navigatingByKeyboardMode
        if @initialHighlightedMonth is @highlightedMonth then @update() else @redraw()    # This mimics keypress event (keypress is not working on arrow keys in most browsers)

  update: =>
    days = @listOfDays.find('> li')
    for i in [0..days.length-1]
      day = $(days[i])
      dateFromData = @stringToDate(day.data('date'), @format).getTime()
      day.removeClass(@TODAY_CLASS).removeClass(@SELECTED_CLASS).removeClass(@HIGHLIGHTED_CLASS)
      day.addClass(@TODAY_CLASS)  if dateFromData is @today.getTime()
      day.addClass(@SELECTED_CLASS)  if @selectedDate? and dateFromData is @selectedDate.getTime()
      day.addClass(@HIGHLIGHTED_CLASS)  if @highlightedDate? and dateFromData is @highlightedDate.getTime()

  redraw: =>
    @navMonth.text( Constants.MONTHS[@language][@highlightedMonth-1] + ' ' + @highlightedYear )
    @listOfDays.empty()
    # Create previous month days
    previousMonth = if @highlightedMonth is 1 then 12 else @highlightedMonth - 1
    yearOfPreviousMonth = if @highlightedMonth is 1 then @highlightedYear - 1 else @highlightedYear
    unless @dayOfWeekOfHighlitedMonthFirst is 1
      for i in [1..@previousMonthsDaysToDraw]
        day = daysInMonth(@highlightedYear, @highlightedMonth - 1) - @previousMonthsDaysToDraw + i
        date = @dateToString(new Date(yearOfPreviousMonth, previousMonth-1, day), @format)
        @listOfDays.append("<li class='prev_month' unselectable='on' data-date='#{date}'>#{day}</li>")
    # Create this month days
    for i in [1..@daysInHighlightedMonth]
      date = @dateToString(new Date(@highlightedYear, @highlightedMonth-1, i), @format)
      daysDrawnSoFar = @previousMonthsDaysToDraw + i
      style = if daysDrawnSoFar % 7 is 1 then 'clear: both' else ''
      @listOfDays.append("<li class='this_month' unselectable='on' style='#{style}' data-date='#{date}'>#{i}</li>")
    # Create next month days
    unless @nextMonthsDaysToDraw is 0
      nextMonth = if @highlightedMonth is 12 then 1 else @highlightedMonth + 1
      yearOfNextMonth = if @highlightedMonth is 12 then @highlightedYear + 1 else @highlightedYear
      for i in [1..@nextMonthsDaysToDraw]
        date = @dateToString(new Date(yearOfNextMonth, nextMonth-1, i), @format)
        @listOfDays.append("<li class='next_month' unselectable='on' data-date='#{date}'>#{i}</li>")
    @update()
    # Bind events to days
    days = @listOfDays.find('> li')
    days.on 'click.actionable.datepicker', (event) =>
      @selectedDate = @stringToDate($(event.currentTarget).data('date'), @format)
      @setHighlightedDate @selectedDate
      @redraw()
      @input.val @dateToString(@selectedDate, @format)
      @input.focus()
      @hide()

  show: =>
    @calendar.show()
    @isCalendarShown = true
    $(document).unbind 'click.actionable.datepicker'    # Prevents event spam when user click many times on passive datepicker elements
    $(document).on 'click.actionable.datepicker', (event) =>
      clickedCalendar = if $(event.target).parents().filter(@calendar).length is 0 then false else true
      clickedInput = if $(event.target).filter(@input).length is 0 then false else true
      unless clickedCalendar or clickedInput
        if @selectedDate? then @setHighlightedDate(@selectedDate) else @setHighlightedDate(@today)
        @redraw()
        @hide()

  hide: =>
    @calendar.hide()
    @isCalendarShown = false
    $(document).unbind 'click.actionable.datepicker'




  constructor: (@element) ->
    @TODAY_CLASS = 'today'
    @SELECTED_CLASS = 'selected'
    @HIGHLIGHTED_CLASS = 'highlighted'

    @input = $(@element)
    @input.data('datepicker_object', this)

    @calendar = Utils.initRawDataAttr @input, 'calendar', Constants.STRING, Constants.EMPTY
    @calendar = $(@calendar)
    unless $(@calendar).length is 1
      Utils.debugMessage "'data-calendar' is required to point to unique DOM element, inspect the following:", $(this)
      return
    @language = (Utils.initRawDataAttr @input, 'language', Constants.STRING, 'en').toUpperCase()
    @format = (Utils.initRawDataAttr @input, 'format', Constants.STRING, 'iso').toUpperCase()
    @date = Utils.initRawDataAttr @input, 'date', Constants.STRING, Constants.EMPTY
    @today = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate(), 0, 0, 0, 0)
    if @isStringADate(@date, @format)
      @input.val @date
      @selectedDate = @stringToDate(@date, @format)
      @setHighlightedDate @selectedDate
    else
      @selectedDate = undefined
      @setHighlightedDate(@today)

    html = "<div class='nav' unselectable='on'>
                      <div class='prev' unselectable='on'></div>
                      <div class='month' unselectable='on'></div>
                      <div class='next' unselectable='on'></div>
                    </div>
                    <ul class='legend'></ul>
                    <ul class='days'></ul>"
    @calendar.html(html)
    @navPrev = @calendar.find('> .nav > .prev')
    @navNext = @calendar.find('> .nav > .next')
    @navMonth = @calendar.find('> .nav > .month')
    @legend = @calendar.find('> ul.legend')
    @legend.append("<li unselectable='on'> #{Constants.DAYS_OF_WEEK[@language][i]} </li>")  for i in [0..6]
    @listOfDays = @calendar.find('> ul.days')
    @hide()
    @redraw()

    @navPrev.on 'click.actionable.datepicker', =>
      @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth - 2, Math.min(@highlightedDay, daysInMonth(@highlightedYear, @highlightedMonth - 1))))
      @redraw()
      @input.focus()

    @navNext.on 'click.actionable.datepicker', =>
      @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth, Math.min(@highlightedDay, daysInMonth(@highlightedYear, @highlightedMonth + 1))))
      @redraw()
      @input.focus()

    @navMonth.on 'click.actionable.datepicker', =>
      @input.focus()

    @legend.on 'click.actionable.datepicker', =>
      @input.focus()

    @input.on 'focus.actionable.datepicker', =>
      @show()

    @input.on 'keydown.actionable.datepicker', (event) =>
      if @isCalendarShown
        keyName = KeyboardUtils.decodeKeyCode(event.keyCode)

        @input.trigger 'focus'
        if keyName is 'Escape'
          @hide()
        if keyName is 'Enter'
          event.preventDefault()
          @selectedDate = @highlightedDate
          @input.val @dateToString(@selectedDate, @format)
          @hide()
        if event.ctrlKey and keyName in ['Arrow Left', 'Arrow Right', 'Arrow Up', 'Arrow Down']
          @navigatingByKeyboardMode = true
          if event.shiftKey
            switch keyName
              when 'Arrow Left'
                @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth-2, Math.min(@highlightedDay, daysInMonth(@highlightedYear, @highlightedMonth-1))))
              when 'Arrow Right'
                @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth, Math.min(@highlightedDay, daysInMonth(@highlightedYear, @highlightedMonth+1))))
              when 'Arrow Up'
                @setHighlightedDate(new Date(@highlightedYear+1, @highlightedMonth-1, Math.min(@highlightedDay, daysInMonth(@highlightedYear, @highlightedMonth-1))))
              when 'Arrow Down'
                @setHighlightedDate(new Date(@highlightedYear-1, @highlightedMonth-1, Math.min(@highlightedDay, daysInMonth(@highlightedYear, @highlightedMonth-1))))
          else
            switch keyName
              when 'Arrow Left'
                @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth-1, @highlightedDay - 1 ))
              when 'Arrow Right'
                @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth-1, @highlightedDay + 1))
              when 'Arrow Up'
                @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth-1, @highlightedDay - 7))
              when 'Arrow Down'
                @setHighlightedDate(new Date(@highlightedYear, @highlightedMonth-1, @highlightedDay + 7))
          return false

    @input.on 'keyup.actionable.datepicker', (event) =>
      keyName = KeyboardUtils.decodeKeyCode(event.keyCode)
      if keyName is 'Shift' then @navigatingByKeyboardMode = true       # Making releasing shift also a navigation mode
      if @isStringADate(@input.val(), @format)                          ## This 4 lines
        @selectedDate = @stringToDate(@input.val(), @format)            ## update selected
        unless @navigatingByKeyboardMode                                #|    # This 2 lines update highlighted
          @setHighlightedDate(@selectedDate)                            #|    # date when in navigation mode
      else                                                              ## date when typing
        @selectedDate = undefined                                       ## directly to input
      if (keyName is 'Control' and not event.ctrlKey)                                                                 # Releasing Ctrl key will
        if @selectedDate? then @setHighlightedDate(@selectedDate) else @setHighlightedDate(@today)                    # reset highligted date
      @navigatingByKeyboardMode = false                                                                               # Removes navigation mode set in keydown
      @redraw()                                                                                               # Redraw for both: keydown and keyup event



$ ->

  $.fn.datePicker = ->
    $(this).filter("[data-widget~='datepicker']").first().data('datepicker_object')


