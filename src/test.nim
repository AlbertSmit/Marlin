import nimpad, std/with, sugar


var router: Nimpad = nimpad.init()


with router:
    get "/root", () => "welcome!"
    get "/test", () => "test."
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"
    post "/root/:something/:else", () => "mister postman."


var 
    x = router.find(GET, "/pizza")
    y = router.find(POST, "/root/pizza/cookies")
    z = router.find(GET, "/root")

# if x is Route: echo x.handler()
# if y is Route: echo y
# if z is Route: echo z.handler()
