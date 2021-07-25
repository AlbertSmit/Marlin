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
    rex: string = ""

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
          # extension = temp.find('.', 1)

        if optional != -1:
          # Found an optional flag
          rex = temp[1 .. (optional - 1)]
          pattern &= "(?:/(?P<" & rex & ">[^/]+?))?"
        else:
          rex = temp[1 .. ^1]
          pattern &= "/(?P<" & rex & ">[^/]+?)"

        keys.add(rex)
      else:
        pattern &= "/" & temp
    except:
      break

  return (keys, re("^" & pattern & "/?$"))
