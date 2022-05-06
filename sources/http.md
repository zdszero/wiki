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

