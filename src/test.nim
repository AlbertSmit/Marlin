import nimpad, std/with, sugar


var router: Nimpad = nimpad.init()


with router:
    get "/", () => "welcome!"
    get "/test", () => "test."
    get "/pizza", () => "pizza is ready!"
    get "/hamburger", () => "who ordered a hamburger?"

with router:
    post "/", () => "mister postman."


var 
    x = router.find(GET, "/pizza")
    y = router.find(POST, "/")


echo x.handler(), y.handler()