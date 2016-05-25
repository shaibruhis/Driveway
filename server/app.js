var braintree = require('braintree');
var fs = require('fs');
var https = require('https');
var http = require('http');
var express = require('express');
var Firebase = require("firebase");
var _ = require("underscore");
var momentTZ = require('moment-timezone');
var moment = require('moment');
var myFirebaseRef = new Firebase("https://blinding-fire-154.firebaseio.com/");

var app = express();
var app2 = express();


// SECURE HTTPS 
// PORT: 4430

var options = {
   key  : fs.readFileSync('server.key'),
   cert : fs.readFileSync('server.crt')
};

app.set('port', (process.env.PORT || 4430))

app.get('/', function (req, res) {
   res.send('Hello World!');
});

https.createServer(options, app).listen(app.get('port'), function () {
  console.log("Node app is running at localhost:" + app.get('port'))
});

var gateway = braintree.connect({
  environment: braintree.Environment.Sandbox,
  merchantId: "f7g3p2b4wytrsb2s",
  publicKey: "c4nxbv2tfsr6wfvm",
  privateKey: "fa19dab918b6792c60eba6e267836d54"
});

app.get("/client_token", function (req, res) {
  gateway.clientToken.generate({}, function (err, response) {
  	var clientToken = {
  		"clientToken": response.clientToken
  	}
    res.send(clientToken);
  });
});


// HTTP 
// PORT:8080

app2.set('port', (process.env.other_port || 8080))

http.createServer(app2).listen(app2.get('port'), function() {
  console.log("App is listening on port" + app.get('port'));
});

app2.get('/', function(req, res) {
  res.send('This is the 42JumpStreet precinct.\n')
});
 

app2.get("/client_token", function (req, res) {
  gateway.clientToken.generate({}, function (err, response) {
    var clientToken = {
      "clientToken": response.clientToken
    }
    res.send(response.clientToken);
  });
});

app.post("/checkout", function (req, res) {
  var nonceFromTheClient = req.body.payment_method_nonce;
  // Use payment method nonce here
  gateway.transaction.sale({
  amount: '10.00',
  paymentMethodNonce: nonceFromTheClient,
  options: {
    submitForSettlement: true
  }
  
  }, function (err, result) {

  });
});

// Helper Functions

function getTimeStr() {
  var currentTime = moment().tz("America/Los_Angeles").format("hh:mm a").toUpperCase();
  if(currentTime.charAt(0) === '0') {
    currentTime = currentTime.substr(1);
  }
  return currentTime;
}
// Check Firebase every Minute


setTimeout(checkMinutes,1000);

function checkMinutes(){
  var now = new Date().getMinutes();
  if (now > checkMinutes.prevTime){
    checkFirebase()
    console.log('nextminute arrived');
    console.log(getTimeStr());
  }
  checkMinutes.prevTime = now;
  setTimeout(checkMinutes,1000);
}



var checkFirebase = function() {
  myFirebaseRef.once("value", function(snapshot) {
  snapshot.child("Locations").forEach(function(childSnapshot) {
      var startTime = childSnapshot.child("Start Time").val();
      var endTime = childSnapshot.child("End Time").val();
      var isRented = childSnapshot.child("Rented Until");
      var currentTime = getTimeStr();
   
      if(startTime == currentTime) {
        console.log("inside start time");
        childSnapshot.child("Is Available").ref().set('True');
      }

      if(endTime == currentTime) {
        console.log("inside end time");
        childSnapshot.child("Is Available").ref().set('False');
      }
      
      if(isRented == currentTime) {
        console.log("inside isRented");
        childSnapshot.child("Is Available").ref().set('True');
        childSnapshot.child("Rented Until").ref().set('-1');
      }

    });
  });     
};



