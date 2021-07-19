import nimpad, std/with

var
    router: Nimpad = nimpad.init()

with router:
    get("/")
    get("/test")
    get("/pizza")
    get("/hamburger")

var 
    test = router.find("/pizza")

echo test, router