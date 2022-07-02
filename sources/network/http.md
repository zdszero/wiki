% http
% zdszero
% 2022-05-06

## evolution

### http/0.9

### http/1.0

### http/1.1

### http/2.0

## message

```
HTTP-message    = Request | Response
generic-message = start-line
                  *message-header
                  CRLF
                  [ message-body ]
start-line      = Request-Line | Status-Line
```

### start line

#### Request Line
```
Request-Line = Method SP Request-URI SP HTTP-Version CRLF

Method = "OPTIONS"
       | "GET"
       | "HEAD"
       | "POST"
       | "PUT"
       | "DELETE"
       | "TRACE"
       | extendible-method
extendible-method = token

Request-URL = "*" | absoluteURI | abs_path
```

#### Response Line

* 1xx: Informational - Request received, continuing process
* 2xx: Success - The action was successfully received, understood, and accepted
* 3xx: Redirection - Further action must be taken in order to complete the request
* 4xx: Client Error - The request contains bad syntax or cannot be fulfilled
* 5xx: Server Error - The server failed to fulfill an apparently valid request

```
Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF

Status-Code    = "100"   ; Continue
               | "101"   ; Switching Protocols
               | "200"   ; OK
               | "201"   ; Created
               | "202"   ; Accepted
               | "203"   ; Non-Authoritative Information
               | "204"   ; No Content
               | "205"   ; Reset Content
               | "206"   ; Partial Content
               | "300"   ; Multiple Choices
               | "301"   ; Moved Permanently
               | "302"   ; Moved Temporarily
               | "303"   ; See Other
               | "304"   ; Not Modified
               | "305"   ; Use Proxy
               | "400"   ; Bad Request
               | "401"   ; Unauthorized
               | "402"   ; Payment Required
               | "403"   ; Forbidden
               | "404"   ; Not Found
               | "405"   ; Method Not Allowed
               | "406"   ; Not Acceptable
               | "407"   ; Proxy Authentication Required
               | "408"   ; Request Time-out
               | "409"   ; Conflict
               | "410"   ; Gone
               | "411"   ; Length Required
               | "412"   ; Precondition Failed
               | "413"   ; Request Entity Too Large
               | "414"   ; Request-URI Too Large
               | "415"   ; Unsupported Media Type
               | "500"   ; Internal Server Error
               | "501"   ; Not Implemented
               | "502"   ; Bad Gateway
               | "503"   ; Service Unavailable
               | "504"   ; Gateway Time-out
               | "505"   ; HTTP Version not supported
               | extension-code

extension-code = 3DIGIT

Reason-Phrase  = *<TEXT, excluding CR, LF>
```

### message headers


* HTTP header fields:
    * general-header
    * request-header
    * response-header
    * entity-header

```
message-header = field-name ":" [ field-value ] CRLF

field-name     = token
field-value    = *( field-content | LWS )

field-content  = <the OCTETs making up the field-value
                 and consisting of either *TEXT or combinations
                 of token, tspecials, and quoted-string>
```

