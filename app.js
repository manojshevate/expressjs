var express = require('express');
var constants = require('./src/constants');
var api = require('./src/api/test');
var ui = require('./src/api/ui');

var app = express();
const numCPUs = require('os').cpus().length;
const cluster = require('cluster');


// Static Files Handling
app.use('/static',express.static(__dirname + '/public/'));
// REST API
app.use('/api', api);
// UI Routing
app.use('/', ui);


// Clustering 
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
	app.listen(constants.port, function () {
	  console.log('Example app listening on port',constants.port);
	});
}




