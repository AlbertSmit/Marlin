# Types
type
  Method* {.pure.} = enum
    GET, POST, OPTIONS
  Route* = object
    `method`: Method
    route: string
  Nimpad* = object
    routes: seq[Route]


# Procs
proc `$`(p: Nimpad): string =
  result = $p.routes & " are the routes."

proc init*(): Nimpad = 
  Nimpad(routes: @[])

proc create(s: var Nimpad, m: Method, r: string): Nimpad {.discardable.} =
  s.routes.add(Route(`method`: m, route: r))

proc `find`*(s: var Nimpad, path: string): Route {.discardable.} =
  s.routes[s.routes.find(Route(route: path))]

template get*(s: var Nimpad, r: string): Nimpad =
  s.create(GET, r)

template post*(s: var Nimpad, r: string): Nimpad =
  s.create(POST, r)

template options*(s: var Nimpad, r: string): Nimpad =
  s.create(OPTIONS, r)