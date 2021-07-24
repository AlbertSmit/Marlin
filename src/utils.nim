import json

template `.`*(jsn: JsonNode, field: untyped): untyped =
  jsn[astToStr(field)]

template insert*(jsn: JsonNode, field, value: untyped): untyped =
  jsn[field] = %value
