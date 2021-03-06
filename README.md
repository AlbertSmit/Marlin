<!-- ![Language: Nim](https://img.shields.io/badge/language-Nim-yellow) -->
![Language: Nim](https://img.shields.io/static/v1?label=written%20with%20love,%20in&message=Nim&color=yellow)
![License: MIT](https://img.shields.io/github/license/AlbertSmit/Marlin)
[![Version](https://img.shields.io/github/v/release/AlbertSmit/Marlin?include_prereleases)](https://github.com/AlbertSmit/Marlin/releases)


# Marlin 🦈


> Marlins are among the fastest marine swimmers <sup >[` 1 `](#footnote)</sup>

> ...greatly exaggerated speeds are often claimed in popular literature  <sup >[` 1 `](#footnote)</sup>

<sub id="footnote"><sup> **`1`** — Source: [Wikipedia](https://en.wikipedia.org/wiki/Marlin) </sup></sub>

## What the fish is this?


**A [Nim](https://github.com/nim-lang/Nim) port of [Lukeed](https://github.com/lukeed)'s [Trouter 🐟](https://github.com/lukeed/regexparam).**

> Long story short; it's a _router_.

Writing this port to 
- understand the inner workings
- get better at writing libraries
- have a shiny new router to work with

<sub><sup>_Work in progress._</sub></sup>


## Usage
```nim
import marlin, std/with, sugar

with marlin.router:
  get "/pizza", () => "pizza is ready!"
  get "/hamburger", () => "who ordered a hamburger?"
  get "/songs/:artist/reviews/:song?", () => "bruh"
  post "/songs/:artist/:album", () => "mister postman."
```

## Submodules

-  `src/regex`   →   Nim port of [Lukeed](https://github.com/lukeed)'s `RegexParams`.
