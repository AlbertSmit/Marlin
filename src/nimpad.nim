import sugar, sequtils


# Types
type
  Method* = enum
    POST, GET, OPTIONS
  Route* = tuple
    `method`: Method
    route: string
    handler: proc(): string{.closure.}
  Nimpad* = object
    routes: seq[Route]


# Procs & Templates
proc init*: Nimpad = 
  Nimpad(routes: @[])
  
proc create(s: var Nimpad, m: Method, r: string, h: () -> string): Nimpad {.discardable.} =
  s.routes.add((m, r, h))

template get*(s: var Nimpad, r: string, h: () -> string): Nimpad =
  s.create(GET, r, h)

template post*(s: var Nimpad, r: string, h: () -> string): Nimpad =
  s.create(POST, r, h)

template options*(s: var Nimpad, r: string, h: () -> string): Nimpad =
  s.create(OPTIONS, r, h)


proc `find`*(s: var Nimpad, m: Method, path: string): Route {.discardable.} =
  try:
    return s.routes[s.routes.map(i => i.route).find(path)]
  except IndexDefect:
    echo "Not found"