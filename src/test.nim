import marlin, std/with, sugar


var router: Marlin = marlin.init()


with router:
    get "/", () => "root levels."
    get "/root", () => "welcome!"
    get "/test", () => "test."
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"
    post "/root/:something/:else", () => "mister postman."
    use "/root", () => "bruh"
    get "/users/:what/books/:bro?", () => "bruh"
    get "/test/:something/whut/:else", () => "mister postman."
    get "/test/*", () => "wildcarded"


var 
    a = router.find(GET, "/")
    b = router.find(GET, "/users/123/books/bible")
    c = router.find(GET, "/root/:fake")
    d = router.find(GET, "/users/999/whut/poop")
    x = router.find(GET, "/pizza")
    y = router.find(POST, "/root/pizza/cookies")
    z = router.find(GET, "/root")

if a is Response: echo a
if b is Response: echo b
if y is Response: echo y
