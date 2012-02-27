import autobahn.websocket

import sys
from twisted.python import log
from twisted.internet import reactor
from autobahn.websocket import WebSocketServerFactory, WebSocketClientProtocol, WebSocketClientFactory, WebSocketServerProtocol, listenWS, parseWsUrl, connectWS

import json


class WebSocketTestClientProtocol(WebSocketClientProtocol):
    def onOpen(self):
        self.server = self.factory.server
        self.server.clientConnected(self)

    def onMessage(self, msg, binary):
        msg = json.dumps(json.loads(msg), indent=2, sort_keys=True)
        print 'client msg'
        print msg
        self.server.sendMessage(msg, binary)

 
class WebSocketTestServerProtocol(WebSocketServerProtocol):

    def clientConnected(self, client):
        self.client = client
        for msg in self.messageQueue:
            self.client.sendMessage(msg)
        self.messageQueue = None

    def onClose(self, *args):
        self.client.sendClose()
        self.client = None

    def onConnect(self, connectionRequest):
        self.client = None
        self.messageQueue = []

        client_factory = WebSocketProxyClientFactory("ws://localhost:9222%s" % connectionRequest.path,
                                                     debug=False)
        client_factory.server = self
        
        connectWS(client_factory)

    def onMessage(self, msg, binary):
        print 'server msg'

        pretty_msg = json.dumps(json.loads(msg), indent=2, sort_keys=True)
        print msg
        if self.client:
            self.client.sendMessage(msg, binary=binary, payload_frag_size=2048 * 2048)
        else:
            self.messageQueue.append(msg)


class WebSocketProxyServerFactory(WebSocketServerFactory):
    protocol = WebSocketTestServerProtocol

    def serverConnectionFailed(self, connector, reason):
       """noop"""

    def serverConnectionLost(self, connector, reason):
       """noop"""
 

class WebSocketProxyClientFactory(WebSocketClientFactory):
    protocol = WebSocketTestClientProtocol

    def clientConnectionFailed(self, connector, reason):
        """noop"""

    def clientConnectionLost(self, connector, reason):
        """noop"""


if __name__ == '__main__':
 
   log.startLogging(sys.stdout)

   server_factory = WebSocketProxyServerFactory("ws://localhost:9020", debug = True)
   

   listenWS(server_factory, interface='127.0.0.1')
   reactor.run()
