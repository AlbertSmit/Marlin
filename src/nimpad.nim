import regex, parse


# Types
type
  Method* = enum
    POST, GET, OPTIONS
  Handler* = proc(): string{.noSideEffect, gcsafe, locks: 0.}
  Route* = tuple
    `method`: Method
    route: string
    keys: seq[string]
    pattern: Regex
    handler: Handler
  Nimpad* = object
    routes: seq[Route]
  NotFound* = object of ValueError

# Procs & Templates
proc init*: Nimpad = 
  Nimpad(routes: @[])
  
proc create(s: var Nimpad, m: Method, r: string, h: Handler): Nimpad {.discardable.} =
  var (keys, pattern) = parse(r)
  s.routes.add((m, r, keys, pattern, h))

template get*(s: var Nimpad, r: string, h: Handler): Nimpad =
  s.create(GET, r, h)

template post*(s: var Nimpad, r: string, h: Handler): Nimpad =
  s.create(POST, r, h)

template options*(s: var Nimpad, r: string, h: Handler): Nimpad =
  s.create(OPTIONS, r, h)

proc `find`*(s: var Nimpad, m: Method, path: string): Route {.discardable, raises: [NotFound].} =
  var 
    rm: RegexMatch

  try:
    for i, e in s.routes[0 .. ^1]:
      if e.`method` == m:
        if e.keys.len == 0:
          discard path.match(e.pattern, rm)
          echo "match ", e.route
          # Test -> Get keys from RegEx captures.
          for i, match in rm.captures:
            for i, val in match:
              echo "path val ", path[val]

        elif e.keys.len > 0:
          var matches = path.findAll(e.pattern)
          for i, key in e.keys:
            echo "key: " & key & " + match: " & matches[0].group(i, path)[0]

        # elif:
          # echo ""

        # Return default response
        return s.routes[i]

  except:
    raise newException(NotFound, "Route not found")
