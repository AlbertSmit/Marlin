import ../src/marlin, std/with, sugar


with marlin.router:
    get "/", () => "root levels."
    get "/root", () => "welcome!"
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"
    post "/songs/:artist/:album", () => "mister postman."
    get "/songs/:artist/reviews/:song?", () => "bruh"
    get "/test/*", () => "wildcard"


var 
    a = router.find(GET, "/")
    b = router.find(GET, "/songs/kanye/reviews/power")
    c = router.find(POST, "/songs/kanye/yeezus")


if a is Response: echo a
if b is Response: echo b
if c is Response: echo c
