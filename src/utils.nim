## Additional utilities to make life easier.

import json

template `.`*(jsn: JsonNode, field: untyped): untyped =
  ## Get a value through dot notation. 
  ## {.experimental: "dotOperators".} required at beginning of file.

  jsn[astToStr(field)]

template insert*(jsn: JsonNode, field, value: untyped): untyped =
  ## Add an untyped value to a `JsonNode`.
  jsn[field] = %value
