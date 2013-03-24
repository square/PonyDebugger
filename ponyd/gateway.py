
import tornado
import tornado.web
import tornado.websocket
import tornado.options

from ponyd.command import PonydCommand
from ponyd.argbase import Arg

import os

import json
import uuid

import argparse

import bonjour

import logging

from ponyd.constants import DEFAULT_DEVTOOLS_PATH

logger = logging.getLogger('gateway')

args = None


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

                logger.info("Dev tools connecting to device %s",
                            device.deviceID)
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
            if payload.get('method') == 'Gateway.registerDevice':
                self._registerDevice(payload['params'])
            else:
                logger.info("dropping device message: %s", msg)

    def on_close(self):
        self.app_state.unregisterDevice(self)

    def _registerDevice(self, params):
        self.deviceID = params.get('device_id')
        self.device_model = params.get('device_model')
        self.device_name = params.get('device_name')
        self.app_id = params.get('app_id')
        self.app_name = params.get('app_name')
        self.app_version = params.get('app_version')
        self.app_build = params.get('app_build')

        # Optional.
        self.app_icon_base64 = params.get('app_icon_base64', None);

        self.app_state.registerDevice(self)

        # Announce existence.
        logger.info("Device %s Registered (%s, %s)" % (self.deviceID,
                                                       self.device_model,
                                                       self.device_name))

    @property
    def deviceInfo(self):
      return dict(
          device_id=self.deviceID,
          device_model=self.device_model,
          device_name=self.device_name,
          connection_id=self.connectionId,
          app_id=self.app_id,
          app_name=self.app_name,
          app_version=self.app_version,
          app_build=self.app_build,
          app_icon_base64=self.app_icon_base64,
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
            logger.info("dropping devtools message: %s", msg)


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
        payload = json.dumps(dict(id=self.message_id, method=method, params=params))
        self.write_message(payload)
        self.message_id += 1

        logger.info('Sending Method: %s', method)

class Gateway(PonydCommand):
    """Runs PonyDebugger's gateway"""
    __subcommand__  = 'serve'

    static_path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'web'))

    verbose = Arg('-v', '--verbose',
                  help='verbose logging',
                  action='store_true')

    satic_path = Arg('-s', '--static-path',
                     help='path for static files [default: %(default)s]',
                     default=static_path)

    devtools_path = Arg('-d', '--devtools-path',
                        help='path for dev tools/inspector [default: %(default)s]',
                        default=DEFAULT_DEVTOOLS_PATH)

    listen_port = Arg('-p', '--listen-port',
                      help='port to listen on [default: %(default)s]', 
                      default=9000, 
                      type=int,
                      metavar='PORT')

    listen_interface = Arg('-i', '--listen-interface',
                           help='interface to listen on. [default: %(default)s]',
                           default='127.0.0.1',
                           metavar='IFACE')

    bonjour_name = Arg('-b', '--bonjour-name',
                       help='name of the bonjour service. [default: %(default)s]',
                       default='Pony Gateway')

    def __call__(self):
        if not os.path.exists(self.devtools_path):
            print "Error: devtools directory %s does not exist. Use 'ponyd update-devtools' to download a compatible version of Chrome Developer Tools." % self.devtools_path
            return

        if self.verbose:
            tornado.options.enable_pretty_logging()
            logger = logging.getLogger()
            logger.setLevel(logging.INFO)

        application = tornado.web.Application([
            (r"/devtools/page/([0-9]*)/?", DevToolsHandler),
            (r"/lobby", LobbyHandler),
            (r"/device", DeviceHandler),
            (r"/devtools/(.*)", tornado.web.StaticFileHandler, {"path": self.devtools_path}),
            (r"/(.*)", tornado.web.StaticFileHandler, {"path": self.static_path, "default_filename": 'index.html'}),
        ])

        print "PonyGateway starting. Listening on %s:%s" % (self.listen_interface, self.listen_port)

        bonjour.register_service(self.bonjour_name, "_ponyd._tcp", self.listen_port)

        application.listen(self.listen_port, self.listen_interface)
        tornado.ioloop.IOLoop.instance().start()

