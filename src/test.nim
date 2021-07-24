import nimpad, std/with, sugar


var router: Nimpad = nimpad.init()


with router:
    get "/", () => "root levels."
    get "/root", () => "welcome!"
    get "/test", () => "test."
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"
    post "/root/:something/:else", () => "mister postman."
    use "/root", () => "bruh"
    get "/users/:id/books/:title", () => "bruh"
    get "/root/:something/:else", () => "mister postman."
    get "/test/*", () => "wildcarded"


var 
    a = router.find(GET, "/")
    b = router.find(GET, "/users/123/books/bible")
    c = router.find(GET, "/root/:fake")
    d = router.find(GET, "/test/999/whut/poop")
    x = router.find(GET, "/pizza")
    y = router.find(POST, "/root/pizza/cookies")
    z = router.find(GET, "/root")

if a is Response: echo a
if b is Response: echo b
if y is Response: echo y
