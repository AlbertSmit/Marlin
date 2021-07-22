import regex, parse


# Types
type
  Method* = enum
    POST, GET, OPTIONS
  Handler* = proc(): string{.noSideEffect, gcsafe, locks: 0.}
  Route* = tuple
    `method`: Method
    route: string
    pattern: Regex
    handler: Handler
  Nimpad* = object
    routes: seq[Route]
  NotFound* = object of ValueError

# Procs & Templates
proc init*: Nimpad = 
  Nimpad(routes: @[])
  
proc create(s: var Nimpad, m: Method, r: string, h: Handler): Nimpad {.discardable.} =
  s.routes.add((m, r, parse(r).pattern, h))

template get*(s: var Nimpad, r: string, h: Handler): Nimpad =
  s.create(GET, r, h)

template post*(s: var Nimpad, r: string, h: Handler): Nimpad =
  s.create(POST, r, h)

template options*(s: var Nimpad, r: string, h: Handler): Nimpad =
  s.create(OPTIONS, r, h)

proc `find`*(s: var Nimpad, m: Method, path: string): Route {.discardable, raises: [NotFound].} =
  try:
    for i, e in s.routes[0 .. ^1]:
      if path.match(e.pattern) and e.`method` == m:
        return s.routes[i]

  except:
    raise newException(NotFound, "Route not found")
