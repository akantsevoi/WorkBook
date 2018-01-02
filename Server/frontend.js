(function($, window) {
    $.fn.replaceOptions = function(options) {
      var self, $option;
  
      this.empty();
      self = this;
  
      $.each(options, function(index, option) {
        $option = $("<option></option>")
          .attr("value", option.value)
          .text(option.text);
        self.append($option);
      });
    };
  })(jQuery, window);

$(function () {

    // for better performance - to avoid searching in DOM
    var input = $('#input');
    var status = $('#status');
    var button = $('#button');
    var select = $('#select');

    var currentSelect = ""
    var objects = {}

    window.WebSocket = window.WebSocket || window.MozWebSocket;
    
    // if browser doesn't support WebSocket, just show some notification and exit
    if (!window.WebSocket) {
        content.html($('<p>', { text: 'Sorry, but your browser doesn\'t '
                                    + 'support WebSockets.'} ));
        input.hide();
        $('span').hide();
        return;
    }

    // open connection
    var connection = new WebSocket('ws://localhost:1337/editor');

    connection.onopen = function () {
        // first we want users to enter their names
        input.removeAttr('disabled');
        status.text('Connected');
    };

    connection.onerror = function (error) {
        // just in there were some problems with conenction...
        input.html($('<p>', { text: 'Sorry, but there\'s some problem with your '
                                    + 'connection or the server is down.' } ));
    };

    connection.onmessage = function (message) {
        var string = message.data
        objects = JSON.parse(string)
        setupOptions()
        displayCurrentObject()
    };

    function setupOptions() {
        let keys = Object.keys(objects)
        let newOptions = keys.map((elem, index) => {
            return {text: elem, value: index}
        });

        if (currentSelect.length == 0 && keys.length > 0) {
            currentSelect = keys[0]
        }

        console.log("new objects: " + JSON.stringify(objects))

        select.replaceOptions(newOptions)
    }

    function displayCurrentObject() {
        input.val("")
        let keys = Object.keys(objects)

        if (keys.includes(currentSelect)) {
            console.log("Setup new object: " + JSON.stringify(objects[currentSelect]))
            input.val(JSON.stringify(objects[currentSelect]))
        }
    }

    button.click(function() {
        let value = input.val()
        let jsonObject = JSON.parse(value)
        objects[currentSelect] = jsonObject
        let string = JSON.stringify(objects)
        console.log("send new JSON: " + string)
        connection.send(string)
      });

      select.change(function(newValue) {
        let index = select.val()
        currentSelect = Object.keys(objects)[index]

        console.log("new value: " + currentSelect)
        displayCurrentObject()
      });
});