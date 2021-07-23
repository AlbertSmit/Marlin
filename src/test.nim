import nimpad, std/with, sugar


var router: Nimpad = nimpad.init()


with router:
    get "/", () => "root levels."
    get "/root", () => "welcome!"
    get "/test", () => "test."
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"
    post "/root/:something/:else", () => "mister postman."


var 
    a = router.find(GET, "/")
    x = router.find(GET, "/pizza")
    y = router.find(POST, "/root/pizza/cookies")
    z = router.find(GET, "/root")

# if a is Response: echo a
# if x is Response: echo x
if y is Response: echo y.params
# if z is Response: echo z
