import regex, tables, sequtils, sugar, json, macros
import utils, regex/parser


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
  Marlin* = object 
    routes: seq[Route]


# Procs & Templates
proc init*: Marlin = 
  Marlin(routes: @[])

proc `add`*(s: var Marlin, m: Method, r: string, h: Handler): Marlin {.discardable.} =
  var (keys, pattern) = parse(r)
  s.routes.add((m, r, keys, pattern, h))

# TODO: Handlers should be a sequence here.
proc `use`*(s: var Marlin, r: string, h: Handler): Marlin {.discardable.} =
  var (keys, pattern) = parse(r)
  s.routes.add((ALL, r, keys, pattern, h))

# All the HTTP methods go in here.
template all*(s: var Marlin, r: string, h: Handler): Marlin = s.add(ALL, r, h)
template get*(s: var Marlin, r: string, h: Handler): Marlin = s.add(GET, r, h)
template head*(s: var Marlin, r: string, h: Handler): Marlin = s.add(HEAD, r, h)
template patch*(s: var Marlin, r: string, h: Handler): Marlin = s.add(PATCH, r, h)
template options*(s: var Marlin, r: string, h: Handler): Marlin = s.add(OPTIONS, r, h)
template connect*(s: var Marlin, r: string, h: Handler): Marlin = s.add(CONNECT, r, h)
template delete*(s: var Marlin, r: string, h: Handler): Marlin = s.add(DELETE, r, h)
template trace*(s: var Marlin, r: string, h: Handler): Marlin = s.add(TRACE, r, h)
template post*(s: var Marlin, r: string, h: Handler): Marlin = s.add(POST, r, h)
template put*(s: var Marlin, r: string, h: Handler): Marlin = s.add(PUT, r, h)


proc `find`*(s: var Marlin, m: Method, path: string): Response {.discardable.} =
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
          # TODO: Finish this block's logic.
          if matches.any(m => m.namedGroups.len > 0):
            for i, match in matches:
              params.insert($i, i)
              handlers.add(e.handler)

        elif e.keys.len > 0:
          if matches.len == 0:
            continue
          for i, key in e.keys:
            # TODO: This syntax could be heaps prettier/readable.
            params.insert(key, matches[0].group(i, path)[0])
            handlers.add(e.handler)

        elif path.match(e.pattern, rm):
          handlers.add(e.handler)

    except:
      break

  return (params, handlers)

# Initialise self
var router* = init()
