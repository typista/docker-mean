var express = require('express');
var bodyParser = require('body-parser');
var mongodb = require('mongodb');

var app = express();
var BSON = mongodb.BSONPure;
var db, users;

app.use(express.static('front'));
app.use(express.static('dist'));
app.use(bodyParser.json());

mongodb.MongoClient.connect("mongodb://localhost:27017/test", function(err, database) {
  db = database;
  users = db.collection("users");
  app.listen(3000);
});

// 一覧取得
app.get("/api/users", function(req, res) {
  users.find().toArray(function(err, items) {
    res.send(items);
  });
});

// 個人取得
app.get("/api/users/:_id", function(req, res) {
  users.findOne({_id: new BSON.ObjectID(req.params._id)}, function(err, item) {
    res.send(item);
  });
});

// 追加
app.post("/api/users", function(req, res) {
  var user = req.body;
  users.insert(user, function() {
    res.send("insert");
  });
});

// 更新
app.post("/api/users/:_id", function(req, res) {
  var user = req.body;
  delete user._id;
  users.update({_id: new BSON.ObjectID(req.params._id)}, user, function() {
    res.send("update");
  });
});

// 削除
app.delete("/api/users/:_id", function(req, res) {
  users.remove({_id: new BSON.ObjectID(req.params._id)}, function() {
    res.send("delete");
  });
});

app.get("/api/test",function(req,res){
  res.send("test");
});
