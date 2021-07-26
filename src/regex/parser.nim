## This module is a Nim port of Lukeed's `RegexParam`.
## The name is pretty implicit of what it does. ;-)

import strutils, regex

type 
  RegexParams* = tuple
    keys: seq[string]
    pattern: Regex

proc parse*(s: string, loose: bool = false): RegexParams =
  ## Parse a string, return RegEx
  
  var 
    chopped: seq[string] = s.split("/")
    keys: seq[string] = @[]
    pattern: string = ""
    current: char = '|'
    temp: string = ""
    name: string = ""

  while chopped.len >= 0:
    try:
      chopped.delete(0)
      temp = chopped[0]
      current = temp[0]

      if current == '*':
        keys.add("wild")
        pattern &= "/(.*)"

      elif current == ':':
        var 
          optionalIndex = temp.find('?', 1)
          extensionIndex = temp.find('.', 1)
          hasOptional = optionalIndex != -1
          hasExtension = extensionIndex != -1

        if hasOptional:
          name = temp[1 .. (optionalIndex - 1)]
          pattern &= "(?:/(?P<" & name & ">[^/]+?))?"

          if hasExtension:
            name = temp[1 .. (extensionIndex - 1)]
            pattern &= (if hasOptional: "?\\" else: "\\") & temp[1 .. extensionIndex - 1]

        else:
          name = temp[1 .. ^1]
          pattern &= "/(?P<" & name & ">[^/]+?)"

        keys.add(name)

      else:
        pattern &= "/" & temp

    except:
      break

  return (keys, re("^" & pattern & (if loose: "(?=$|/)" else: "/?$")))
