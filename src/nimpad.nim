import sugar, sequtils, regex, parse


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


# Procs & Templates
proc init*: Nimpad = 
  Nimpad(routes: @[])
  
proc create(s: var Nimpad, m: Method, r: string, p: Regex, h: Handler): Nimpad {.discardable.} =
  s.routes.add((m, r, p, h))

template get*(s: var Nimpad, r: string, h: Handler): Nimpad =
  var p = parse(r)
  s.create(GET, r, p.pattern, h)

template post*(s: var Nimpad, r: string, h: Handler): Nimpad =
  var p = parse(r)
  s.create(POST, r, p.pattern, h)

template options*(s: var Nimpad, r: string, h: Handler): Nimpad =
  var p = parse(r)
  s.create(OPTIONS, r, p.pattern, h)

proc `find`*(s: var Nimpad, m: Method, path: string): Handler {.discardable.} =
  for i, route in s.routes[0 .. ^1]:
    if path.match(route.pattern):
      echo route

  return s.routes[s.routes.map(i => i.route).find(path)].handler