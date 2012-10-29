import functools
from tornado import ioloop
import pybonjour
import logging

logger = logging.getLogger('bonjour')

def register_service(name, regtype, port):
    def connection_ready(service, fd, events):
        pybonjour.DNSServiceProcessResult(service)

    def register_callback(sdRef, flags, errorCode, name, regtype, domain):
        if errorCode == pybonjour.kDNSServiceErr_NoError:
            logger.debug('Registered bonjour service %s.%s', name, regtype)

    service = pybonjour.DNSServiceRegister(name=name,
                                           regtype=regtype,
                                           port=port,
                                           callBack=register_callback)
    io_loop = ioloop.IOLoop.instance()
    callback = functools.partial(connection_ready, service)
    io_loop.add_handler(service.fileno(), callback, io_loop.READ)
