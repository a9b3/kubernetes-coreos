var http = require('http')

http.createServer(function(req, res) {
  res.writeHead(200)
  res.end('Hello World!')
})
.listen(8080, function() {
  console.log('app listening on port 8080')
})
