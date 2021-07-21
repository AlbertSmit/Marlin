import strutils, regex


type 
  RegexParams = tuple
    keys: seq[string]
    pattern: Regex


proc parse*(s: string): RegexParams =
  var 
    chop: seq[string] = s.split("/")
    keys: seq[string] = @[]
    pattern: string = ""
    tmp: string = ""
    c: char = '|'

  while chop.len >= 0:
    try:
      chop.delete(0)
      tmp = chop[0]
      c = tmp[0]

      if c == '*':
        keys.add("wild")
        pattern &= "/(.*)"
      elif c == ':':
        keys.add(tmp[1 .. ^1])
        pattern &= "/([^/]+?)"
      else:
        pattern &= "/" & tmp
    except:
      break

  return (keys, re(pattern))
