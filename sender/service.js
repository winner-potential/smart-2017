const http = require('http')
const url = require('url')
const cluster = require('cluster')

if (cluster.isMaster) {
  const express = require('express')
  const app = express()
  const FastPriorityQueue = require("fastpriorityqueue")
  
  var numThreads = Math.max(require('os').cpus().length - 1, 1)
  var idCounter = 0

  var spawnNewWorker = function() {
    var worker = cluster.fork()
    worker.jobs = 0
    worker.on('message', function(msg) {
      if(msg.done) {
        worker.jobs --;
      }
      console.log(JSON.stringify(msg));
    })
    return worker
  }

  // Spawn workers
  var workers = []; 
  for (var t = 0; t < numThreads; t++) {
    var worker = spawnNewWorker()
    worker.id = t
    workers.push(worker)
    console.log(JSON.stringify({"msg": "worker spawned", "worker": t}))
  }

  // based on https://stackoverflow.com/a/12467377
  function setSimpleInterval(callback, delay) {
    var self = {};
    // attributes
    var counter = 0;
    var start = new Date().getTime();

    // Delayed running of the callback.
    function delayed() {
      if(self.cancled)
        return;
      callback(delay);
      counter ++;
      var diff = (new Date().getTime() - start) - counter * delay;
      setTimeout(delayed, delay - diff);
    }

    // start timer
    setTimeout(delayed, delay);
    return self;
  }
  function clearSimpleInterval(ref) {
    ref.cancled = true;
  }

  var start = function(installation, endpoint, replication) {
    var begin = new Date().getTime();
    var queue = new FastPriorityQueue(function(a,b) {return a.jobs < b.jobs})
    for(var k in workers) {
      queue.add(workers[k])
    }
    var now = new Date().getTime()
    var target = {
      hostname: endpoint.hostname,
      path: endpoint.path,
      port: endpoint.port,
      now: now,
      installation: installation
    }
    for(var i = 0; i < replication; i ++) {
      var id = installation + "-" + i + "-" + new Date().getTime()
      var worker = queue.poll()
      console.log(JSON.stringify({"time": new Date().getTime(), "id": id, "state": "scheduled", "worker": worker.id}))
      worker.jobs ++
      worker.send({
        id: id, 
        time: now + 1000/replication * i,
        target: target
      })
      queue.add(worker)
    }
    console.log(JSON.stringify({"time": new Date().getTime(), "installation": installation, "runtime": new Date().getTime() - begin}))
  }

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
      var interval = setSimpleInterval(function() {
        start(installation, endpoint, replication);
      }, 1000);
    
      setTimeout(function() {
        console.log(JSON.stringify({'msg': 'stopped', 'id': id}))
        clearSimpleInterval(interval);
      }, duration * 1000);
    }, delay * 1000);
    res.send();
  })

  var port = 3000
  app.listen(port, () => console.log(JSON.stringify({'msg': 'service initialized', 'port': port})))
} else {
  process.on('uncaughtException', function (err) {
    process.send({"time": new Date().getTime(), "error": err});
  }); 
  process.on('message', function(config) {
    var time = config.time || new Date().getTime();
    setTimeout(function() {
      var id = config.id;
      var done = false;
      var options = {
        host: config.target.hostname,
        path: config.target.path,
        port: config.target.port,
        method: 'POST',
        headers: {'Content-Type': 'application/json'}
      };
      var E = Math.random(); // J
      process.send({"time": new Date().getTime(), "id": id, "state": "started"})
      var req = http.request(options, (res) => {
        res.setEncoding('utf8');
        var msg = {"time": new Date().getTime(), "id": id, "state": "response", "code": res.statusCode};
        if(!done) {
          // Only add done once (master uses this to decrese job counter)
          msg.done = true;
          done = true;
        }
        process.send(msg);
        res.on('data', (chunk) => {
          //~ console.log(`BODY: ${chunk}`);
        });
        res.on('end', () => {
          //~ console.log('No more data in response.');
        });
      });
      req.on('error', function(err) {
        var msg = {"time": new Date().getTime(), "id": id, "state": "error", "error": err};
        if(!done) {
          // Only add done once (master uses this to decrese job counter)
          msg.done = true;
          done = true;
        }
        process.send(msg);
      });
      req.write(JSON.stringify({
        "time": config.target.now,
        "station": config.target.installation,
        "id": id,
        "energy": E
      }));
      req.end();
    }, Math.max(0, time - new Date().getTime()));
  });
}