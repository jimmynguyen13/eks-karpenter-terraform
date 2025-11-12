const http = require("http");
const port = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
  if (req.method === "GET" && req.url === "/time") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end(new Date().toISOString());
  } else {
    res.writeHead(404);
    res.end("Not found");
  }
});
server.listen(port, () => console.log(`listening ${port}`));
