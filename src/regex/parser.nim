import strutils, regex


type 
  RegexParams* = tuple
    keys: seq[string]
    pattern: Regex


proc parse*(s: string, loose: bool = false): RegexParams =
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
          optional = temp.find('?', 1)
          extension = temp.find('.', 1)

        if optional != -1:
          # Found an optional flag
          name = temp[1 .. (optional - 1)]
          pattern &= "(?:/(?P<" & name & ">[^/]+?))?"
          if extension != -1:
            # Add when extension has been found
            name = temp[1 .. (extension - 1)]
            pattern &= (if optional != -1: "?\\" else: "\\") & temp[1 .. extension - 1]
        else:
          name = temp[1 .. ^1]
          pattern &= "/(?P<" & name & ">[^/]+?)"

        keys.add(name)
      else:
        pattern &= "/" & temp
    except:
      break

  return (keys, re("^" & pattern & "/?$"))
