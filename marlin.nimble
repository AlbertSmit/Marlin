# Package

version       = "0.1.0"
author        = "Albert"
description   = "A simplistic Nim router"
license       = "MIT"
binDir        = "output"
bin           = @["src/marlin", "development/test", "development/server", "regex/parser"]

# Dependencies

requires "nim >= 1.4.6", "regex"

