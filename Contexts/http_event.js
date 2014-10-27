// HTTP

// Event type enum
var awnHTTPEventType = {
    GET: 0,
    POST: 1
}

var eventType = event.data.event_type
var url = "REPLACE WITH YOUR OWN REQUESTB.IN URL"

if (eventType == awnHTTPEventType.GET) {
    // Send a HTTP GET request
    var urlParams = { "message": "get message from http_event!" }
    http.get(url, JSON.stringify(urlParams))
    console.log("HTTP GET webhook fired")
} else {
    // Send a HTTP POST request
    var body = { "message": "post message from http_event!" }
    var headers = { "Content-Type": "application/json"}
    http.post(url, JSON.stringify(body), JSON.stringify(headers))
    console.log("HTTP POST webhook fired")
}

// Inspect the results of these 2 HTTP GET and POST requests by going to http://requestb.in/, generating a URL and placing it in the var url up above
// URL is only good for up to 48 hours