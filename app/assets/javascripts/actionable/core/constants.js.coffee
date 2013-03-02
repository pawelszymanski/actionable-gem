class Constants

  constructor: ->
    @STRING = '_string'
    @INTEGER_POSITIVE = '_integer_positive'
    @INTEGER_NOT_NEGATIVE = '_integer_not_negative'
    @BOOLEAN = '_boolean'
    @REGEXP = '_regexp'
    @REQUIRED = '_required'
    @SELECTOR = '_selector'
    @SELF = '_self'
    @EMPTY = ''
    @RESTORE = '_restore'
    @REPLACE = '_replace'

    @DAYS_OF_WEEK =
      'EN': ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
      'DE': ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So']
      'FR': ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di']
      'IT': ['Lu', 'Ma', 'Me', 'Gi', 'Ve', 'Sa', 'Do']
      'ES': ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do']
      'PL': ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'N']
    @MONTHS =
      'EN': ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
      'DE': ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember']
      'FR': ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']
      'IT': ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre']
      'ES': ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
      'PL': ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień']


  constToHumanString: (constant) =>
    return 'empty'  if constant is @EMPTY
    return '?'



@Constants = new Constants


