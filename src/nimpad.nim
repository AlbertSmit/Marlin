import regex, parse, tables, sequtils, sugar, json

{.experimental: "dotOperators".}


# Types
type
  Method* = enum
    POST, GET, OPTIONS
  Handler* = proc(): string {.noSideEffect, gcsafe, locks: 0.}
  Response* = object
    params: JsonNode
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


# Utils
template `.`(jsn: JsonNode, field: untyped): untyped =
  jsn[astToStr(field)]

template insert(jsn: JsonNode, field, value: untyped): untyped =
  jsn[field] = %value


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
    params: JsonNode = %*{}
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
              params.insert($i, i)

        elif e.keys.len > 0:
          if matches.len == 0:
            continue
          for i, key in e.keys:
            params.insert(key, matches[0].group(i, path)[0])

        elif path.match(e.pattern, rm):
          handlers.add(e.handler)

    echo params

    return Response(params: params, handlers: handlers)

  except:
    raise newException(NotFound, "Route not found")
