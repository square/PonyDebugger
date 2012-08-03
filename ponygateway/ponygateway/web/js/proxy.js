
$(function() {
  var Device = Backbone.Model.extend({
    initialize: function() {
      this.set( { debugger_url : this.debuggerURL() } );
    },

    clear: function() {
      this.destroy();
    },

    debuggerURL: function() {
      return "devtools/devtools.html?host=" + document.location.host + "&page=" + this.get('page');
    }
  });

  var DeviceList = Backbone.Collection.extend({
    model: Device,
    deviceWithConnectionId: function(connection_id) {
      return _.find(this.models, function(device) { return device.get('connection_id') == connection_id; });
    }
  });

  var Devices = new DeviceList;

  var DeviceView = Backbone.View.extend({
    tagName: "li",
    template: Handlebars.compile(($('#device-template').html())),

    initialize: function() {
      this.model.bind('change', this.render, this);
      this.model.bind('destroy', this.remove, this);
    },

    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    },

    clear: function() {
      this.model.clear();
    }
  });

  var AppView = Backbone.View.extend({
    el: $("#pony-gateway"),
    socket: new WebSocket("ws://" + document.location.host + "/lobby"),
    connectionTemplate: Handlebars.compile(($('#status-template').html())),

    initialize: function() {
      this.devices = this.$("#device-list");
      this.noDevices = this.$("#no-devices");
      this.connectionStatus = this.$("#connection-status");
      
      Devices.bind('add', this.addOne, this);
      Devices.bind('reset', this.addAll, this);
      Devices.bind('all', this.render, this);

      this.$("#connection-url").html("ws://" + document.location.host + "/device");

      this.connect();
    },

    render: function() {
      if (Devices.length) {
        this.devices.show();
        this.noDevices.hide();
      } else {
        this.devices.hide();
        this.noDevices.show();
      }
    },

    connect: function() {
      this.setConnectionStatus("Connecting to gateway...");

      var self = this;
      this.socket.onopen = function() { self.socketOpened.apply(self, arguments); };
      this.socket.onclose = function() { self.socketClosed.apply(self, arguments); };
      this.socket.onmessage = function() { self.socketMessaged.apply(self, arguments); };
    },

    socketOpened: function() {
      this.setConnectionStatus("Connected to gateway");
    },

    socketClosed: function() {
      var retryInterval = 1000;
      console.log('connection closed, retrying in ' + (retryInterval / 1000.0) + ' seconds');

      var self = this;
      window.setTimeout( function() { self.connect(); }, retryInterval);
    },

    socketMessaged: function(message) {
      var payload = JSON.parse(message.data);
      this.handleMethod(payload.method, payload.params);
    },

    handleMethod: function(method, params) {
      if (method == "Gateway.deviceAdded") {
        this.deviceAdded.call(this, params);
      } else if (method == "Gateway.deviceRemoved") {
        this.deviceRemoved.call(this, params);
      }
    },

    deviceAdded: function(params) {
      Devices.add(new Device(params));
    },

    deviceRemoved: function(params) {
      var device = Devices.deviceWithConnectionId(params.connection_id);
      Devices.remove(device);
      device.clear();
    },

    setConnectionStatus: function(connectionStatus) {
      this.connectionStatus.html(this.connectionTemplate( { status: connectionStatus } ));
    },

    addOne: function(device) {
      var view = new DeviceView( { model: device } );
      this.devices.append(view.render().el);
    },

    addAll: function() {
      Devices.each(this.addOne);
    }

  });

  var App = new AppView;
});

