const http = require('http')
const url = require('url')
const express = require('express')
const app = express()

var idCounter = 0

var start = function(installation, endpoint, replication) {
  var time = new Date();
  var E = Math.random(); // J

  var options = {
    host: endpoint.hostname,
    path: endpoint.path,
    port: endpoint.port,
    method: 'POST',
    headers: {'Content-Type': 'application/json'}
  };
  var send = function(nr) {
    setTimeout(function() {
      var id = installation + "-" + nr + "-" + new Date().getTime();
      console.log(JSON.stringify({"time": new Date().getTime(), "id": id}));
      var req = http.request(options, (res) => {
          res.setEncoding('utf8');
          if(res.statusCode != 200 && res.statusCode != 204) {
              console.log(JSON.stringify({"time": new Date().getTime(), "error": "Bad status code " + res.statusCode, "id": id}));
          }
          res.on('data', (chunk) => {
            //~ console.log(`BODY: ${chunk}`);
          });
          res.on('end', () => {
            //~ console.log('No more data in response.');
          });
        });
      req.on('error', function(err) {
        console.log(JSON.stringify({"time": new Date().getTime(), "error": err, "id": id}));
      });
      req.write(JSON.stringify({
        "time": time.getTime(),
        "station": installation,
        "id": id,
        "energy": E
      }));
      req.end();
    }, 1000/replication * nr);
  };
  for(var i = 0; i < replication; i ++) {
    send(i);
  }
};

process.on('uncaughtException', function (err) {
  console.log(JSON.stringify({"time": new Date().getTime(), "error": err}));
}); 

app.get('/start/:installation/:replication/:duration/:delay', function (req, res) {
  // name of installation
  var installation = req.params.installation || "unknown";
  // target url
  var endpoint = url.parse(req.query.endpoint || "http://localhost:1880/endpoints/pvreceiver");
  // replication
  var replication = parseInt(req.params.replication) || 1;
  // duration in seconds
  var duration = parseInt(req.params.duration) || 30;
  // duration in seconds
  var delay = parseInt(req.params.delay) || 30;

  var id = ++ idCounter;
  setTimeout(function() {
    console.log({'msg': 'start', 'id': id, 'installation': installation, 'endpoint': req.query.endpoint, 'replication': replication, 'duration': duration});
    var interval = setInterval(function() {
      start(installation, endpoint, replication);
    }, 1000);
  
    setTimeout(function() {
      console.log(JSON.stringify({'msg': 'stopped', 'id': id}))
      clearInterval(interval);
    }, duration * 1000);
  }, delay * 1000);
  res.send();
})

var port = 3000
app.listen(port, () => console.log(JSON.stringify({'msg': 'initialized', 'port': port})))
