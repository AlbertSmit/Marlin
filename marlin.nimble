# Package

version       = "0.1.0"
author        = "Albert"
description   = "A simplistic Nim router"
license       = "MIT"
srcDir        = "src"
binDir        = "output"
bin           = @["marlin", "test", "server", "regex/parser"]

# Dependencies

requires "nim >= 1.4.6", "regex"

