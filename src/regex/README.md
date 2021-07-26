# RegexParam

Nim port of [Lukeed](https://github.com/lukeed)'s [RegexParam](https://github.com/lukeed/regexparam).

## Usage

```nim
var
  string = "/books/horror/pizza"
  (pattern, keys) = string.parse('/books/:genre/:title?')

# pattern => /^\/books\/([^\/]+?)(?:\/([^\/]+?))?\/?$/i
# keys => ['genre', 'title']
```
