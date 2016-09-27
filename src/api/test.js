var express = require('express');
var fs = require('fs');

var router = express.Router();

router.get('/list', function(req, res){
	res.json({'name': 'Manoj Shevate', 'mobile': '+91 9960682190'});
});

router.get('/sample', function(req, res){
	fs.readFile('./data/sample.json', 'utf8', function (err,data) {
	  if (err) {
	    return console.log(err);
	  }
	  else {
	  	res.json(JSON.parse(data));
	  }
	  console.log(data);
	});
});

module.exports = router;