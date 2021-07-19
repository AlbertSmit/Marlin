import nimpad, std/with, sugar


var router: Nimpad = nimpad.init()


with router:
    get("/", () => "yo")
    get("/test", () => "yo")
    get("/pizza", () => "yo")
    get("/hamburger", () => "yo")


var x = router.find(GET, "/pizza")


echo x.handler()