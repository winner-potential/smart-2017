var http = require('http');
var url = require('url');

// name of installation
var installation = (process.argv.length > 2 ? process.argv[2] : false) || "unknown";
// target url
var endpoint = url.parse((process.argv.length > 3 ? process.argv[3] : false) || "http://localhost:1880/endpoints/pvreceiver");
// replication
var replication = (process.argv.length > 4 ? parseInt(process.argv[4]) : false) || 1;

console.log(JSON.stringify({
  host: endpoint.hostname,
  path: endpoint.path,
  port: endpoint.port,
  installation: installation,
  endpoint: endpoint,
  replication: replication
}));

var send = function() {
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
      var req = http.request(options, function(){});
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

setInterval(function() {
  send();
}, 1000);
