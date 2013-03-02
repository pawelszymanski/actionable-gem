class Validations

  PREDEFINED_REGEXPS =
    'asSimpleEmail':     /^[\w\.\%\+\-]+@[a-z\d.-]+\.(?:[a-z]{2}|biz|cat|com|edu|gov|int|mil|net|org|pro|tel|xxx|aero|asia|coop|info|jobs|mobi|name|museum|travel)$/i
    'asExtendedEmail':   /^[\w\.\%\+\-\!\#\$\&\'\*\/\=\?\^\`\{\|\}\~]+@[a-z\d.-]+\.(?:[a-z]{2}|biz|cat|com|edu|gov|int|mil|net|org|pro|tel|xxx|aero|asia|coop|info|jobs|mobi|name|museum|travel)$/i
    'asName':            /^[a-z]+[a-z-'\s]{1,}$/i
    'asIdentifier':      /^[a-z]+[\w-]{1,}$/i
    'asAddress':         /^[a-z\d\/\s-.]{2,}$/i

    'asInteger':         /^[+|-]?\d+$/
    'asUnsignedInteger': /^\d+$/
    'asPositiveInteger': /^[+]?\d+$/
    'asNegativeInteger': /^[-]{1}\d+$/
    'asFloat':           /^[+|-]?\d+([,|.]?\d+)?$/
    'asUnsignedFloat':   /^\d+([,|.]?\d+)?$/
    'asPositiveFloat':   /^[+]?\d+([,|.]?\d+)?$/
    'asNegativeFloat':   /^[-]{1}?\d+([,|.]?\d+)?$/

    'asIBANGlobal':      /^[a-z]{2}\d{2}(\s*[\d|a-z]\s*){8,30}$/i
    'asSWIFT':           /^[a-z]{6}[a-z\d]{2}([a-z\d]{3})?$/i

    'asNamePL':          /^[a-ząćęłńóśżźĄĆĘŁŃÓŚŻŹ]+[a-ząćęłńóśżźĄĆĘŁŃÓŚŻŹ\-\'\s]+$/i
    'asAddressPL':       /^[a-ząćęłńóśżźĄĆĘŁŃÓŚŻŹ]+[a-ząćęłńóśżźĄĆĘŁŃÓŚŻŹ\d-\.\/\s]+$/i
    'asPostcodePL':      /^\d{2}[- ]\d{3}$/
    'asPeselPL':         /^\d{11}$/
    'asSeriaDowoduPL':   /^[a-z]{3}\d{6}$/
    'asNIPPL':           /^((\d{3}[- ]\d{3}[- ]\d{2}[- ]\d{2})|(\d{3}[- ]\d{2}[- ]\d{2}[- ]\d{3})|(\d{10}))$/
    'asRegonPL':         /^\d{9}|\d{14}$/
    'asCarPlatesPL':     /^[a-z\d]{6}|[a-z\d]{7}$/
    'asIBANPL':          /^(pl){1}(\s*\d\s*){26}$/i



  VALIDATION_FUNCTIONS =
    asIBANGlobal: (string) ->                                                                   # Since Javascript auto type conversion we operate on strings
      temp = []                                                                                 # init array
      string = string.replace(/\s/g, '').toUpperCase()                                          # Remove spaces and upppercase all letters
      length = string.length                                                                    # Get length of the string
      temp[i] = string.charAt(i)  for i in [0..length-1]                                        # Convert to array
      for i in [0..3]                                                                           # Move first 4 characters (country code and checksum) to end of an array
        temp.push temp[0]                                                                       #
        temp.shift()                                                                            #
      pharsedString = ''                                                                        # init string
      for i in [0..length-1]                                                                    # Go through array...
        if isNaN(parseInt(temp[i])) then temp[i] = ((temp[i].charCodeAt(0)) - 55).toString()    # ... if it's letter convert it to number
        pharsedString = pharsedString + temp[i]                                                 # ... concat to pharsedString
      parts = []                                                                                # init array
      parts[0] = pharsedString.substr(0,9)                                                      # First part of string is to be 9 first digits, still operating on strings
      pharsedString = pharsedString.slice(9,pharsedString.length)                               #
      nextPart = 1                                                                              # init var for loop
      while pharsedString.length > 1                                                            # Slice rest of pharsedString into 7 characters strings
        parts[nextPart] = pharsedString.substr(0,7)                                             #
        pharsedString = pharsedString.slice(7,pharsedString.length)                             #
        nextPart = nextPart + 1                                                                 #
      tmp = parseInt(parts[0].removeLeadingZeros())                                             # Get mod 97 of first part... ...since for Javascript 10%3; isn't 010%3; we have to remove leading zeros
      tmp = 0  if isNaN(tmp)                                                                    # ... and check if it was zeros only and make the number equal to 0 if so
      result = parseInt(tmp) % 97                                                               # Now we can get modulo of first part, then...
      for i in [1..parts.length-1]                                                              # ... iterate on parts...
        tmp = (result.toString() + parts[i]).removeLeadingZeros()                               # ... again checking for leading zeros
        tmp = 0  if isNaN(tmp)                                                                  # ... and defending against string made of '0's only
        result = tmp % 97                                                                       # ... finally get mod 97 of (result_of_prev_operation + this_part)
      if result is 1 then return true else return false                                         # result should be 1 for proper IBAN number

    asSWIFT: (string) ->
      return true

    asPeselPL: (string) ->
      characters = []
      values = []
      weights = [1, 3, 7, 9, 1, 3, 7, 9, 1, 3]
      products= []
      characters[i-1] = string.charAt(i-1)  for i in [1..11]
      values[i-1] = parseInt(characters[i-1])  for i in [1..11]
      products[i-1] = values[i-1]*weights[i-1]  for i in [1..10]
      if (10 - (eval(products.join('+')) % 10)) is values[10] then return true else return false

    asSeriaDowoduPL: (string) ->
      characters = []
      values = []
      weights = [7, 3, 1, 9, 7, 3, 1, 7, 3]
      products = []
      characters[i-1] = string.charAt(i-1)  for i in [1..9]
      values[i-1] = (characters[i-1].toUpperCase().charCodeAt(0)) - 55  for i in [1..3]
      values[i-1] = parseInt(characters[i-1])  for i in [4..9]
      products[i-1] = values[i-1]*weights[i-1]  for i in [1..9]
      console.log '1'  if eval(products.join('+')) % 10 is 0
      if eval(products.join('+')) % 10 is 0 then return true else return false

    asNIPPL: (string) ->
      string = string.replace(/-|\s/g, '')
      characters = []
      values = []
      weights = [6, 5, 7, 2, 3, 4, 5, 6, 7]
      products = []
      characters[i-1] = string.charAt(i-1)  for i in [1..10]
      values[i-1] = parseInt(characters[i-1])  for i in [1..10]
      products[i-1] = values[i-1]*weights[i-1]  for i in [1..9]
      if eval(products.join('+')) % 11 is values[9] then return true else return false

    asRegonPL: (string) ->
      if string.length is 9
        characters = []
        values = []
        weights = [8, 9, 2, 3, 4, 5, 6, 7]
        products = []
        characters[i-1] = string.charAt(i-1)  for i in [1..9]
        values[i-1] = parseInt(characters[i-1])  for i in [1..9]
        products[i-1] = values[i-1]*weights[i-1]  for i in [1..8]
        if eval(products.join('+')) % 11 is values[8] then return true else return false
      else    # if not 9 then 14 digits, at this step regExp test is passed
        characters = []
        values = []
        weights = [2, 4, 8, 5, 0, 9, 7, 3, 6, 1, 2, 4, 8]
        products = []
        characters[i-1] = string.charAt(i-1)  for i in [1..14]
        values[i-1] = parseInt(characters[i-1])  for i in [1..14]
        products[i-1] = values[i-1]*weights[i-1]  for i in [1..13]
        if eval(products.join('+')) % 11 is values[13] then return true else return false

    asIBANPL: (string) ->
      return @asIBANGlobal(string)



  isPredefinedRegExp: (patternName) ->
    if PREDEFINED_REGEXPS[patternName]? then true else false

  getPredefinedRegExp: (patternName) ->
    PREDEFINED_REGEXPS[patternName]

  validate: (value, pattern) ->
    patternRegExp = if @isPredefinedRegExp(pattern) then @getPredefinedRegExp(pattern) else new RegExp(pattern.slice(1,-1))
    regExpTestPassed = patternRegExp.test value
    if regExpTestPassed
      functionTestPassed = true
      functionTestPassed = VALIDATION_FUNCTIONS[pattern](value)  if VALIDATION_FUNCTIONS[pattern]?

    if regExpTestPassed and functionTestPassed then return true else return false



@Validations = new Validations


