class KeyboardUtils

  constructor: ->

    @KEY_CODES =

      '27'  : 'Escape'

      '112' : 'F1'                      # IE: summoning help can't be prevented via preventDefault()
      '113' : 'F2'
      '114' : 'F3'
      '115' : 'F4'
      '116' : 'F5'
      '117' : 'F6'
      '118' : 'F7'
      '119' : 'F8'
      '120' : 'F9'
      '121' : 'F10'
      '122' : 'F11'
      '123' : 'F12'

      '44'  : 'Print Screen'            # Firefox, Chrome, IE, Opera: fired only on keyup
      '145' : 'Scroll Lock'
      '19'  : 'Pause'

      '45'  : 'Insert'
      '46'  : 'Delete'
      '36'  : 'Home'
      '35'  : 'End'
      '33'  : 'Page Up'
      '34'  : 'Page Down'

      '38'  : 'Arrow Up'
      '37'  : 'Arrow Left'
      '40'  : 'Arrow Down'
      '39'  : 'Arrow Right'

      '192' : 'Tilda'
      '49'  : '1'
      '50'  : '2'
      '51'  : '3'
      '52'  : '4'
      '53'  : '5'
      '54'  : '6'
      '55'  : '7'
      '56'  : '8'
      '57'  : '9'
      '48'  : '0'
      '173' : 'Minus'                   # Firefox
      '189' : 'Minus'                   # Chrome, IE, Opera
      '61'  : 'Plus'                    # Firefox
      '187' : 'Plus'                    # Chrome, IE, Opera
      '8'   : 'Backspace'

      '9'   : 'Tab'                     # Not triggered on keyup (browsers just tab to another focusable element)
      '81'  : 'q'
      '87'  : 'w'
      '69'  : 'e'
      '82'  : 'r'
      '84'  : 't'
      '89'  : 'y'
      '85'  : 'u'
      '73'  : 'i'
      '79'  : 'o'
      '80'  : 'p'
      '219' : 'Open bracket'
      '221' : 'Close bracket'
      '220' : 'Back slash'

      '20'  : 'Caps Lock'
      '65'  : 'a'
      '83'  : 's'
      '68'  : 'd'
      '70'  : 'f'
      '71'  : 'g'
      '72'  : 'h'
      '74'  : 'j'
      '75'  : 'k'
      '76'  : 'l'
      '59'  : 'Semicolon'               # Firefox
      '186' : 'Semicolon'               # Chrome, IE, Opera
      '222' : 'Quote'
      '13'  : 'Enter'

      '16'  : 'Shift'
      '90'  : 'z'
      '88'  : 'x'
      '67'  : 'c'
      '86'  : 'v'
      '66'  : 'b'
      '78'  : 'n'
      '77'  : 'm'
      '188' : 'Comma'
      '190' : 'Period'
      '191'  : 'Slash'

      '17'  : 'Control'
      '18'  : 'Alt'                     # IE, Opera: left Alt summons browser's menu - this can't be prevented; Right Alt triggers both Alt and Control on keydown event, triggers Control key on keyup event
      '32'  : 'Space'
      '91'  : 'Windows'                 # System action can't be prevented via preventDefault()
      '93'  : 'Menu'                    # Firefox, Chrome, IE: system action can't be prevented via preventDefault(), Opera: ignores Menu key in inputs

      '144' : 'Num Lock'
      '111' : 'Numpad Slash'
      '106' : 'Numpad Multiply'
      '109' : 'Numpad Minus'
      '107' : 'Numpad Plus'

      '103' : 'Numpad 7'                 # Num Lock on in this section
      '104' : 'Numpad 8'
      '105' : 'Numpad 9'
      '100' : 'Numpad 4'
      '101' : 'Numpad 5'
      '102' : 'Numpad 6'
      '97'  : 'Numpad 1'
      '98'  : 'Numpad 2'
      '99'  : 'Numpad 3'
      '96'  : 'Numpad 0'
      '110' : 'Numpad Period'

      '12' : 'Numpad 5'                  # Num Lock off, other keys with Num Lock on trigger primary keys (arrows, Page Up etc.)

  decodeKeyCode: (keyCode) =>
    if @KEY_CODES[keyCode]? then return @KEY_CODES[keyCode] else return 'Actionable: KeyboardUtils: unknown key: (' + keyCode + ')'

@KeyboardUtils = new KeyboardUtils


