import asynchttpserver, asyncdispatch, nish, json, std/with, sugar

proc onError(err: int = 404, req: Request, res: Response) {.async.} =
    await req.respond(Http404, "Page not found")

proc listen() {.async.} =
    var 
        server = newAsyncHttpServer()
        router = nish.init()

    with router:
        get "/", () => "Yo!"
        get "/test", () => "test!"

    proc handler(req: Request) {.async.} =
        var route = router.find(GET, req.url.path)
        echo route, typeof route
        if route is Response:
            let headers = {"Content-type": "text/plain; charset=utf-8"}
            await req.respond(Http200, $(route.params), headers.newHttpHeaders())
        else:
            await req.respond(Http404, "Not found")
    
    server.listen Port(8080)
    while true:
        if server.shouldAcceptRequest():
            await server.acceptRequest(handler)
        else:
            poll()


asyncCheck listen()
runForever()