浏览器的诞生，让操作系统变成一个通道，一边连接着计算机的系统能力，一边连接着各种各样的应用程序，来满足各种各样的用户需求。所以，浏览器的重要性不言而喻，它是互联网世界中最重要的基础设施。

那么，从一个URL到最终呈现出来的网页，这中间经历了哪些工作，下面我们就来探讨一下。

简单说，主要经历了以下这些流程：
1. 浏览器使用HTTP协议或者HTTPS协议，向服务端请求数据；
2. 解析请求回来的数据，构建出DOM树；
3. 计算DOM树上的CSS属性；
4. 根据CSS属性，逐个渲染页面元素，得到内存中的位图；
5. 将内存中一个个位图，进行合成，这会大大提高后续绘制速度；
6. 合成之后，再绘制在界面上。

![浏览器工作流程](../images/brower-workflow.jpg)

在这里，需要知道一个事实——这些工作并不是一件完成之后，再进行后续工作，而是渐进式处理。因为通过HTTP得到的数据是流式数据，而且这么做还会提高用户体验。

>从HTTP请求回来，就产生了流式的数据，后续的DOM树构建、CSS计算、渲染、合成、绘制，都是尽可能地流式处理前一步的产出：即不需要等到上一步骤完全结束，就开始处理上一步的输出，这样我们在浏览网页时，才会看到逐步出现的页面。

# HTTP协议
HTTP(HyperText Transfer Protocol)，超文本传输协议，是一种用于分布式、协作式和超媒体信息系统的应用层协议。HTTP是万维网数据通信的基础。

HTTP协议是基于TCP协议出现的，对TCP协议来说，TCP协议是一条双向的通讯通道，HTTP在TCP的基础上，规定了Request-Response的模式。这个模式决定了通讯必定是由浏览器端首先发起的。

在浏览器中，它只负责一件事，那就是根据URL把数据取回来。

## Request
请求部分，由请求行、请求头和请求体组成。请求行由三部分组成：
- HTTP Method，比如GET、POST；
- 请求（资源）路径；
- 协议名称和版本号。

### Request Header
在请求行之后，是请求头，如下：
```
Accept: */*
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Connection: keep-alive
Cookie: _ga=GA1.2.2128725503.1584892293; LF_ID=1584892318584-7313282-4429790;
Host: time.geekbang.org
Referer: https://time.geekbang.org/
Sec-Fetch-Dest: script
Sec-Fetch-Mode: no-cors
Sec-Fetch-Site: same-origin
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
```
请求头中主要字段的解释：
| 字段 | 含义 | 示例 |
| --- | --- | --- |
| Accept | 指定客户端能够接收的内容类型 | Accept: text/plain, text/html
| Accept-Charset | 浏览器可以接受的字符编码集 | Accept-Charset: iso-8859-5
| Accept-Encoding | 指定浏览器可以支持的web服务器返回内容压缩编码类型 | Accept-Encoding: compress, gzip
| Accept-Language | 浏览器可接受的语言 | Accept-Language: en,zh
| Accept-Ranges | 可以请求网页实体的一个或者多个子范围字段 | Accept-Ranges: bytes
| Authorization | HTTP授权的授权证书 | Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
| Cache-Control | 指定请求和响应遵循的缓存机制 | Cache-Control: no-cache
| Connection | 表示是否需要持久连接（HTTP 1.1默认进行持久连接） | Connection: close
| Cookie | 发送给web服务器的cookie | Cookie: $Version=1; Skin=new;
| Content-Length | 请求的内容长度 | Content-Length: 348
| Content-Type | 请求的与实体对应的MIME信息 | Content-Type: application/x-www-form-urlencoded
| Date | 求发送的日期和时间 | Date: Tue, 15 Nov 2010 08:12:31 GMT
| Host | 指定请求的服务器的域名和端口号 | Host: www.zcmhi.com
| If-Match | 只有请求内容与实体相匹配才有效 | If-Match: “737060cd8c284d8af7ad3082f209582d”
| If-Modified-Since | 如果请求的部分在指定时间之后被修改则请求成功，未被修改则返回304代码 | If-Modified-Since: Sat, 29 Oct 2010 19:43:31 GMT
| If-None-Match | 如果内容未改变返回304代码，参数为服务器先前发送的Etag，与服务器回应的Etag比较判断是否改变 | If-None-Match: “737060cd8c284d8af7ad3082f209582d”
| User-Agent | 发出请求的用户信息 | User-Agent: Mozilla/5.0 (Linux; X11)
| Via | 通知中间网关或代理服务器地址，通信协议 | Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
| Warning | 关于消息实体的警告信息 | Warn: 199 Miscellaneous warning

在请求头之后，用一个空行（两个换行符）则是请求体，如果需要提交数据，则会包含文件或者表单数据。

### HTTP Method
- GET：浏览器通过地址栏访问页面都是GET方法。
- POST：表单提交产生POST方法。
- HEAD：跟GET类似，只返回请求头，多数由JavaScript发起。
- PUT：添加资源，更多的是用POST。
- DELETE：删除资源。
- CONNECT：多用于HTTPS和WebSocket。
- OPTIONS：一般用于调试，多数线上服务都不支持。
- TRACE：一般用于调试，多数线上服务都不支持。

### HTTP Request Body
一些常见的body格式是：
- application/json：一般数据通常使用这种。
- application/x-www-form-urlencoded：使用form表单提交数据时使用。
- multipart/form-data：上传文件时使用。
- text/xml：XML格式。

## Response
响应部分，也有响应行、响应头和响应体组成。响应行由协议和版本、状态码和状态文本组成，紧接着是响应头。同样，在一个空行（两个换行符）之后，则是响应体，内容是HTML文本。
```html
HTTP/1.1 301 Moved Permanently
Date: Fri, 25 Jan 2019 13:28:12 GMT
Content-Type: text/html
Content-Length: 182
Connection: keep-alive
Location: https://time.geekbang.org/
Strict-Transport-Security: max-age=15768000

<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>openresty</center>
</body>
</html>
```
### Response Header
响应头中的主要字段：
| 字段 | 含义 |
| --- | --- |
| Cache-Control | 缓存控制,用于通知各级缓存保存的时间,例如max-age=0,表示不要缓存。
| Connection | 连接类型,Keep-Alive表示复用连接。
| Content-Encoding | 内容编码方式,通常是gzip
| Content-Length | 内容的长度,有利于浏览器判断内容是否已经结束。
| Content-Type | 内容类型,所有请求网页的都是text/html
| Date | 当前的服务器日期。
| ETag | 页面的信息摘要,用于判断是否需要重新到服务端取回页面。
| Expires | 过期时间,用于判断下次请求是否需要到服务端取回页面。
| Keep-Alive | 保持连接不断时需要的一些信息,如 timeout=5,max=100
| Last-Modified | 页面上次修改的时间。
| Server | 服务端软件的类型。
| Set-Cookie | 设置 cookie,可以存在多个。
| Via | 服务端的请求链路,对一些调试场景至关重要的一个头。

### HTTP Status code
- 1xx：临时回应，表示客户端请继续。对浏览器来说比较陌生，因为被浏览器处理掉了。
- 2xx：请求成功。开发者最喜欢的状态。
    - 200：OK，请求成功。
    - 201：Created，已在服务器上成功创建了一个或多个新资源。
- 3xx: 表示请求的目标有变化，希望客户端进一步处理。
    - 301：Moved Permanently，永久性跳转。实际上301更接近于一种报错，提示客户端下次别来了。
    - 302：Move Temporarily，临时性跳转。
    - 304：跟客户端缓存没有更新。产生这个状态的前提是：客户端本地已经有缓存的版本，并且在Request中告诉了服务端，当服务端通过时间或者tag，发现没有更新的时候，就会返回一个不含body的304状态。
- 4xx：客户端请求错误。
    - 400：Bad Request，语义有误，服务器无法理解。
    - 401：Unauthorized，当前请求需要用户验证。
    - 403：Forbidden，无权限。
    - 404：Not Found，请求的页面不存在。
- 5xx：服务端请求错误。
    - 500：Internal Server Error，服务端内部错误。
    - 501：Not Implemented，服务器不支持当前请求所需要的某个功能。
    - 502：Bad Gateway，作为网关或者代理工作的服务器尝试执行请求时，从上游服务器接收到无效的响应。
    - 503：Service Unavailable，服务端暂时性错误，可以一会再试。

## HTTP 2
HTTP 2是HTTP 1.1的升级版，主要解决的是性能不足问题。它比HTTP1.1的两大改进点是：
- 支持服务端推送；
- 支持TCP连接复用。

服务端推送能够在客户端发送第一个请求到服务端时，提前把一部分内容推送给客户端，放入缓存当中，这可以避免客户端请求顺序带来的并行度不高，从而导致的性能问题。

TCP连接复用，则使用同一个TCP连接来传输多个HTTP请求，避免了TCP连接建立时的三次握手开销，和初建TCP连接时传输窗口小的问题。