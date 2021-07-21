import strutils, regex


type 
  RegexParams* = tuple
    keys: seq[string]
    pattern: Regex


proc parse*(s: string): RegexParams =
  var 
    chopped: seq[string] = s.split("/")
    keys: seq[string] = @[]
    pattern: string = ""
    current: char = '|'
    temp: string = ""

  # TODO: Add &= operator macro/proc

  while chopped.len >= 0:
    try:
      chopped.delete(0)
      temp = chopped[0]
      current = temp[0]

      if current == '*':
        keys.add("wild")
        pattern = pattern & "/(.*)"
      elif current == ':':
        keys.add(temp[1 .. ^1])
        pattern = pattern & "/([^/]+?)"
      else:
        pattern &= "/" & temp
    except:
      break

# ^\/hamburger\/([^\/]+?)\/?$
  echo "/^" & pattern & "/?$" & "/i"

  return (keys, re("/^" & pattern & "/?$" & "/i"))
