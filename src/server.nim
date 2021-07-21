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
        var m = router.find(GET, req.url.path)
        let headers = {"Content-type": "text/plain; charset=utf-8"}

        echo m

        var resp: string = ""
        if m is Route and len(m.route) != 0:
            resp = m.handler()
        else:
            resp = "No route. Sorry."

        await req.respond(Http200, resp, headers.newHttpHeaders())
    
    server.listen Port(8080)
    while true:
        if server.shouldAcceptRequest():
            await server.acceptRequest(cb)
        else:
            poll()

asyncCheck main()
runForever()