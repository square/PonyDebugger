import tornado
import tornado.web
import tornado.websocket
import tornado.options

import os

import json
import uuid

import argparse

import logging

logger = logging.getLogger('gateway')

args = None

def parse_args():
    global args
    static_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'prproxy', 'static'))
    parser = argparse.ArgumentParser(description='Gateway server')

    parser.add_argument('-v', '--verbose', help='verbose logging', action='store_true')

    parser.add_argument('-s', '--static-path', help='path for static files [default: %(default)s]', default=static_path)
    parser.add_argument('-d', '--devtools-path', help='path for dev tools/inspector [default: %(default)s]', default=os.path.join(static_path, 'devtools'))

    parser.add_argument('-p', '--listen-port', help='port to listen on [default: %(default)s]', default=9000, type=int, metavar='PORT')
    parser.add_argument('-i', '--listen-interface', help='interface to listen on. [default: %(default)s]', default='0.0.0.0', metavar='IFACE')

    args = parser.parse_args()
    
    

class AppState(object):
    def __init__(self):
        self.currentPageNumber = 1
        self.lobbies = set()
        self.devices = set()
        self.devTools = set()

    def registerDevice(self, device):
        device.page = self.currentPageNumber
        self.currentPageNumber += 1

        self._sendToWeb('Gateway.deviceAdded', device.deviceInfo)
        
        self.devices.add(device)

    def unregisterDevice(self, device):
        if device in self.devices:
            self.devices.remove(device)
        self._sendToWeb('Gateway.deviceRemoved', device.deviceInfo)

        if device.devTools:
            device.devTools.device = None
            device.devTools = None

    def addLobby(self, lobby):
        self.lobbies.add(lobby)
        for device in self.devices:
            lobby.write_method('Gateway.deviceAdded', device.deviceInfo)

    def removeLobby(self, lobby):
        self.lobbies.remove(lobby)

    def devToolsConnected(self, devTools):
        devTools.waiting = True

        for device in self.devices:
            if device.page == devTools.page:
                devTools.waiting = False

                logger.info("Dev tools connecting to device %s", device.deviceID)
                devTools.device = device
                device.devTools = devTools

                break


    def devToolsClosed(self, devTools):
        # some cleanup
        if devTools.device:
            devTools.device.devTools = None
            devTools.device = None


    def _sendToWeb(self, method, params={}):
        for lobby in self.lobbies:
            lobby.write_method(method, params)

global_app_state = AppState()
 
class DeviceHandler(tornado.websocket.WebSocketHandler):
    app_state = global_app_state

    deviceID = None
    page = None
    devTools = None

    def open(self):
        logger.info("Device Connected")
        self.deviceID = None
        self.connectionId = str(uuid.uuid4())
        return None

    def on_message(self, msg):
        if self.devTools:
            self.devTools.write_message(msg)
        else:
            payload = json.loads(msg)
            if payload['method'] == 'Gateway.registerDevice':
                self._registerDevice(payload['params'])
            else:
                logger.warning("dropping device message: %s", msg)

    def on_close(self):
        self.app_state.unregisterDevice(self)

    def _registerDevice(self, params):
        self.deviceID = params['device_id']
        self.device_model = params['device_model']
        self.device_name = params['device_name']
        self.app_id = params['app_id']

        self.app_state.registerDevice(self)

        # announce my existence
        logger.info("Device %s Registered (%s, %s)" % (self.deviceID,
                                                 self.device_model,
                                                 self.device_name))

    @property
    def deviceInfo(self):
         return dict(device_id=self.deviceID,
                     device_model=self.device_model,
                     device_name=self.device_name,
                     connection_id=self.connectionId,
                     app_id=self.app_id,
                     page=self.page)


class DevToolsHandler(tornado.websocket.WebSocketHandler):
    app_state = global_app_state

    device = None

    def open(self, page):
        self.page = int(page)
        self.app_state.devToolsConnected(self)

    def on_close(self):
        self.app_state.devToolsClosed(self)

    def on_message(self, msg):
        if self.device:
            self.device.write_message(msg)
        else:
            logger.warning("dropping devtools message: %s", msg)

class LobbyHandler(tornado.websocket.WebSocketHandler):
    app_state = global_app_state
    message_id = 0

    def open(self):
        logger.info('Lobby Connected')
        self.app_state.addLobby(self)

    def on_close(self):
        logger.info('Lobby Disconnected')
        self.app_state.removeLobby(self)
    
    def on_message(self, msg):
        pass

    def write_method(self, method, params={}):
        payload = json.dumps(dict(id=self.message_id,
                                  method=method,
                                  params=params))

        self.write_message(payload)

        logger.info('Sending Method: %s', method)

        self.message_id += 1

def main():
    global logger
    #tornado.options.parse_command_line()

    parse_args()

    if args.verbose:
        tornado.options.enable_pretty_logging()
        logger = logging.getLogger()
        logger.setLevel(logging.INFO)


    application = tornado.web.Application([
        (r"/devtools/page/([0-9]*)/?", DevToolsHandler),
        (r"/lobby", LobbyHandler),
        (r"/device", DeviceHandler),
        (r"/devtools/(.*)", tornado.web.StaticFileHandler, {"path": args.devtools_path}),
        (r"/(.*)", tornado.web.StaticFileHandler, {"path": args.static_path, "default_filename":'index.html'}),
    ],
    )


    application.listen(args.listen_port, args.listen_interface)
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()
