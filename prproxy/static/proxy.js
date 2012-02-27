
function SocketClient () {
  this.list_elem = document.getElementById('client_list');
  this.info_div = document.getElementById('info_div');
  var self = this;
}

SocketClient.prototype.connect = function () {
  var self = this;

  this.list_elem.innerHTML = '';
  this.info_div.innerHTML = 'status: connecting to gateway...'; 
  this.socket = new WebSocket("ws://" + document.location.host + "/lobby");  
  
  this.socket.onopen = function () {self.onopen.apply(self, arguments);};
  this.socket.onmessage = function () {self.onmessage.apply(self, arguments);};
  this.socket.onclose = function () {self.onclose.apply(self, arguments);};
};

SocketClient.prototype.handleMethod = function (methodName, params) {
  methodName = methodName.split('.')[1];

  console.log('received method', methodName, 'params', params);

  this[methodName].call(this, params)
};

SocketClient.prototype.deviceAdded = function (params) {
  var el = document.createElement('li');
  el.innerHTML = '<a href="devtools/devtools.html?host=' + document.location.host + '&page=' + params.page + '">' + params.device_name + '</a>' + ' <span class="device_details">(' + params.app_id + ', ' + params.device_model + ', ' + params.device_id + ')</span>';
  this.list_elem.appendChild(el);
  this.visibleElems[params.connection_id] = el;
};

SocketClient.prototype.deviceRemoved = function (params) {
  var li = this.visibleElems[params.connection_id];
  li.parentNode.removeChild(li);
};

SocketClient.prototype.onopen = function () {
  this.info_div.innerHTML = 'status: connected to gateway';
  this.list_elem.innerHTML = '';
  this.visibleElems = {};
  console.log('connection to gateway opened');
};

SocketClient.prototype.onmessage = function (message) {
  var payload = JSON.parse(message.data);
  this.handleMethod(payload.method, payload.params);
};

SocketClient.prototype.onclose = function () {
  var retryInterval = 1000.0;
  console.log('connection closed, retrying in ' + (retryInterval/1000.0) + ' seconds');
  var self = this;
  window.setTimeout(function () {self.connect();}, retryInterval);
};


window.addEventListener('load', function () {
    var socketClient = new SocketClient();
    socketClient.connect()
  }
);
