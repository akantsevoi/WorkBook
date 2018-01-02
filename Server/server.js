var WebSocketServer = require('websocket').server;
var http = require('http');
const util = require('util');

const serverPort = 1337

var observableObjects = {}
var clientConnections = {}
var editorConnections = []

var server = http.createServer(function(request, response) {});
server.listen(serverPort, function() { 
  console.log("Server start listen " + serverPort + " port");
});

// create the server
wsServer = new WebSocketServer({
  httpServer: server
});

// WebSocket server
wsServer.on('request', function(request) {
  var connection = request.accept(null, request.origin)
  let requestString = request.resource.replace('/','')
  let params = requestString.split('/')
  let type = params[0]
  if (type == "client") {
    let objectKey = params[1]
    console.log("Client: " + objectKey + " has connected")

    clientConnections[objectKey] = connection

    connection.on('message', function(message) {
      if (message.type == 'utf8') {
        var object = JSON.parse(message.utf8Data)
        for(var key in object) {
          observableObjects[key] = object[key]
        }
        editorConnections.forEach( function(editorConnect) {
          editorConnect.sendUTF(JSON.stringify(observableObjects))
        });
      }
    });

  } else if (type == "editor") {
    console.log("Editor has connected")

    editorConnections.push(connection)
    connection.sendUTF(JSON.stringify(observableObjects))

    connection.on('message', function(message) {
      if (message.type == 'utf8') {
        var objects = JSON.parse(message.utf8Data)
        observableObjects = objects
        sendObjectsToClients(observableObjects, clientConnections)
      }
    });
  }

  connection.on('close', function(closeConnection) {
    if (editorConnections.includes(connection)) {
      console.log("Editor has disconnected")
    } else {
      console.log("Client has disconnected")
      for (var key in clientConnections) {
        console.log("enumerate: " + key)
        if (clientConnections[key] == connection) {
          console.log("delete object for key: " + key)
          delete observableObjects[key]
        }
      }
      editorConnections.forEach( function(editorConnect) {
        editorConnect.sendUTF(JSON.stringify(observableObjects))
      });
    }
  });

  function sendObjectsToClients(objects, connections) {
    for (var connectionKey in connections) {
      for (var objectKey in objects) {
        if (objectKey == connectionKey) {
          var sendObject = {}
          sendObject[objectKey] = objects[objectKey]
          let sendString = JSON.stringify(sendObject)
          console.log("Updated objects to client: " + sendString)
          connections[connectionKey].sendUTF(sendString)
        }
      }
    }
  }
});