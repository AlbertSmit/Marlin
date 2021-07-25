import regex, tables, sequtils, sugar, json
import utils, regex/parser


{.experimental: "dotOperators".}


# Types
type
  Method* = enum
    ALL = "", GET, HEAD, PATCH, OPTIONS, CONNECT, DELETE, TRACE, POST, PUT
  Handler* = 
    proc(): string {.noSideEffect, gcsafe, locks: 0.}
  Response* = tuple
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


# Procs & Templates
proc init*: Nimpad = 
  Nimpad(routes: @[])

proc `add`*(s: var Nimpad, m: Method, r: string, h: Handler): Nimpad {.discardable.} =
  var (keys, pattern) = parse(r)
  s.routes.add((m, r, keys, pattern, h))

proc `use`*(s: var Nimpad, r: string, h: Handler): Nimpad {.discardable.} =
  var (keys, pattern) = parse(r)
  s.routes.add((ALL, r, keys, pattern, h))

# All the HTTP methods go in here.
template all*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(ALL, r, h)
template get*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(GET, r, h)
template head*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(HEAD, r, h)
template patch*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(PATCH, r, h)
template options*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(OPTIONS, r, h)
template connect*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(CONNECT, r, h)
template delete*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(DELETE, r, h)
template trace*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(TRACE, r, h)
template post*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(POST, r, h)
template put*(s: var Nimpad, r: string, h: Handler): Nimpad = s.add(PUT, r, h)

proc `find`*(s: var Nimpad, m: Method, path: string): Response {.discardable.} =
  var 
    isHead: bool = m == HEAD
    handlers: seq[Handler] = @[]
    params: JsonNode = %*{}
    rm: RegexMatch

  for i, e in s.routes[0 .. ^1]:
    try:
      var matches = path.findAll(e.pattern)
      if e.`method` == ALL or e.`method` == m or isHead and e.`method` == GET:
        if e.keys.len == 0:
          if matches.len == 0: 
            continue
          if matches.any(m => m.namedGroups.len > 0):
            for i, match in matches:
              params.insert($i, i)
              handlers.add(e.handler)

        elif e.keys.len > 0:
          if matches.len == 0:
            continue
          for i, key in e.keys:
            params.insert(key, matches[0].group(i, path)[0])
            handlers.add(e.handler)

        elif path.match(e.pattern, rm):
          handlers.add(e.handler)

    except:
      break

  return (params, handlers)

