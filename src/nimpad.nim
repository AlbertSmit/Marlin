# Types
type
  Methods* = enum
    GET, POST, OPTIONS

type
  Nimpad* = object
    routes: seq[string]


# Procs
proc `$`(p: Nimpad): string =
  result = $p.routes & " are the methods."

proc create*(s: var Nimpad, m: Methods, r: string): Nimpad {.discardable.} =
  s.routes.add(r)

proc get*(s: var Nimpad, r: string): Nimpad {.discardable.} =
  s.create(GET, r)

proc post*(s: var Nimpad, r: string): Nimpad {.discardable.} =
  s.create(POST, r)


# Vars
var nimpad = Nimpad(routes: @[])


# Experiments
nimpad.get("oke")
nimpad.get("something")
nimpad.get("pizza")
nimpad.post("pizza")

echo nimpad