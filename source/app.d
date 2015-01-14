
// import vibe.d;
import vibe.core.core;
import vibe.core.log;
import vibe.http.router;
import vibe.http.server;
import vibe.web.web;

import std.stdio;
import std.range;

shared static this()
{
	auto settings = new HTTPServerSettings();
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
    settings.sessionStore = new MemorySessionStore();

    auto router = new URLRouter();
    router.registerWebInterface(new WebInterface());

    listenHTTP(settings, router);
    // logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

class WebInterface
{
    private
    {
        SessionVar!(bool, "authenticated") ms_authenticated;
    }

    void index()
    {
        bool authenticated = ms_authenticated;
        render!("index.dt", authenticated);
    }

    // Fibonacci - GET /fib
    void getFib()
    {
        writeln(recurrence!((seq, i) => seq[0] + seq[1])(0, 1).take(10));
    }

    // POST /login  (username and password are automatically read as form fields)
    void postLogin(string username, string password)
    {
        enforceHTTP(username == "admin" && password == "admin",
            HTTPStatus.forbidden, "Invalid username or password.");
        ms_authenticated = true;
        redirect("/");
    }

    @method(HTTPMethod.POST)
    @path("logout")
    void postLogout()
    {
        ms_authenticated = false;
        terminateSession();
        redirect("/");
    }
}
