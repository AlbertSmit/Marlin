import asynchttpserver, asyncdispatch, sugar, nimpad, std/with


proc main {.async.} =
    var 
        server = newAsyncHttpServer()
        router = nimpad.init()

    with router:
        get "/", () => "welcome!"
        get "/test", () => "test."
        get "/pizza", () => "pizza is ready!"
        get "/hamburger", () => "who ordered a hamburger?"

    proc cb(req: Request) {.async.} =
        var handler = router.find(GET, req.url.path)
        let headers = {"Content-type": "text/plain; charset=utf-8"}
        await req.respond(Http200, handler(), headers.newHttpHeaders())
    
    server.listen Port(8080)
    while true:
        if server.shouldAcceptRequest():
            await server.acceptRequest(cb)
        else:
            poll()

asyncCheck main()
runForever()