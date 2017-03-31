var express = require('express');

var router = express.Router();

router.get('/users', function (req, res) {
  var response = {
    resource: "users",
    verb: "GET",
  }
  res.json(response);
});

router.get('/users/:id', function (req, res) {
  var response = {
    id: req.params.id,
    verb: "GET"
  }
  res.json(response);
});

router.post('/users/:id', function (req, res) {
  var response = {
    id: req.params.id,
    verb: "POST",
    body: req.body,
  }
  res.json(response);
});

router.put('/users/:id', function (req, res) {
  var response = {
    id: req.params.id,
    verb: "PUT",
    body: req.body,
  }
  res.json(response);
});

router.delete('/users/:id', function (req, res) {
  var response = {
    id: req.params.id,
    verb: "DELETE",
  }
  res.json(response);
});

module.exports = router;