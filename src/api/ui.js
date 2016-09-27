var express = require('express');

var router = express.Router();

router.get('/', function (req, res) {
  res.send('Hello World!');
});

router.post('/', function (req, res) {
  res.send(req.body);
});

router.put('/user', function (req, res) {
  res.send('Got a PUT request at /user');
});

router.delete('/user', function (req, res) {
  res.send('Got a DELETE request at /user');
});

module.exports = router;