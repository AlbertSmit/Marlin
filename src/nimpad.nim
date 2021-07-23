import regex, parse, tables, sequtils, sugar


# Types
type
  Method* = enum
    POST, GET, OPTIONS
  Handler* = proc(): string {.noSideEffect, gcsafe, locks: 0.}
  KeyValue = tuple
    key: string
    value: string
  Params* = seq[KeyValue]
  Response* = tuple
    params: Params
    handlers: seq[Handler]
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

proc `find`*(s: var Nimpad, m: Method, path: string): Response {.discardable, raises: [NotFound].} =
  var 
    rm: RegexMatch
    params: Params = @[]
    handlers: seq[Handler] = @[]

  try:
    for i, e in s.routes[0 .. ^1]:
      var matches = path.findAll(e.pattern)
      if e.`method` == m:
        if e.keys.len == 0:
          if matches.len == 0: 
            continue
          if matches.any(m => m.namedGroups.len > 0):
            for i, match in matches:
              params.add((key: $i, value: $i))

        elif e.keys.len > 0:
          if matches.len == 0:
            continue
          for i, key in e.keys:
            params.add((key: key, value: matches[0].group(i, path)[0]))

        elif path.match(e.pattern, rm):
          handlers.add(e.handler)

    return (params, handlers)

  except:
    raise newException(NotFound, "Route not found")
