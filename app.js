var express = require('express');
var app = express();
const numCPUs = require('os').cpus().length;
const cluster = require('cluster');


app.use('/static',express.static(__dirname + '/public/'));

// REST API
app.get('/api/list', function(req, res){
	res.json({'name': 'Manoj Shevate', 'mobile': '+91 9960682190'});
});

// Routing
app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.post('/', function (req, res) {
  res.send('Got a POST request');
});

app.put('/user', function (req, res) {
  res.send('Got a PUT request at /user');
});

app.delete('/user', function (req, res) {
  res.send('Got a DELETE request at /user');
});

console.log('Current directory: ', __dirname);
console.log('CPU count: ', numCPUs);


if (cluster.isMaster) {
	// FOR workers
	for (var i = numCPUs; i >= 0; i--) {
		cluster.fork();
	}
	cluster.on('exit', (worker, code, signal) => {
    	console.log(`worker ${worker.process.pid} died`);
    });
    
} else {
	// Start Web server
	app.listen(3000, function () {
	  console.log('Example app listening on port 3000!');
	});
}




