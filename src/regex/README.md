![Language: Nim](https://img.shields.io/static/v1?label=written%20with%20love,%20in&message=Nim&color=yellow)

# RegexParam

Nim port of [Lukeed](https://github.com/lukeed)'s [RegexParam](https://github.com/lukeed/regexparam).

## Usage

```nim
var
  urlToBeParsed = "/books/horror/pizza"
  (pattern, keys) = urlToBeParsed.parse('/books/:genre/:title?')

# pattern => /^/books/([^/]+?)(?:/([^/]+?))?/?$/i
# keys => ['genre', 'title']
```
