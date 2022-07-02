% web

## web form（网页表单）

A web page allows a user to enter data that is sent to a server for processing, which may includes the following parts:

* checkbox
* radio buttons
* text fields
...

## CGI (Common Gateway Interface)

A interface specification that enables web servers to execute an external program to procoess user requests.

A typical use case occurs when a Web user submits a Web form on a web page that uses CGI. The form's data is sent to the Web server within an HTTP request with a URL denoting a CGI script. The Web server then launches the CGI script in a new computer process, passing the form data to it. The output of the CGI script, usually in the form of HTML, is returned by the script to the Web server, and the server relays it back to the browser as its response to the browser's request.

The very first version of a protocol that enables the web server to be interactive. Still in use, CGI is less efficient than the newer techs.

### web server & web framework

Web server establishes the connection, relays the reqeusts to the web framework and send the responses to the clients. It doesn't care the content the certain request.

Web framework is responsible for dealing with the detail of request, which includes querying the database and generate the response.

Exmaples:

* web servers: nginx, apache
* web frameworks: django, express

### wsgi

[intro](https://zhuanlan.zhihu.com/p/441743099)

Python Web Server Gateway Interface

```
        WSGI
SERVER -------- APP
```

WSGI协议其实是定义了一种server与application解耦的规范，即可以有多个实现WSGI server的服务器，也可以有多个实现WSGI application的框架，那么就可以选择任意的server和application组合实现自己的Web应用。
