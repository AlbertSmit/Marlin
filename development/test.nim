import ../src/marlin, std/with, sugar, json


with marlin.router:
    get "/", () => "root levels."
    get "/root", () => "welcome!"
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"
    post "/songs/:artist/:album", () => "mister postman."
    get "/songs/:artist/reviews/:song?", () => "bruh"
    get "/songs/:artist/:song", () => "bruh"
    get "/test/*", () => "wildcard"


var 
    a = router.find(GET, "/")
    b = router.find(GET, "/songs/kanye/reviews/power")
    d = router.find(GET, "/songs/kanye/yeezus.mp3")
    c = router.find(POST, "/songs/kanye/yeezus")


if a is Response: echo "A ", a
if b is Response: echo "B ", b
if c is Response: echo "C ", c
if d is Response: echo "D ", d
