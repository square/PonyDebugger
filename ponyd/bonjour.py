import select
import pybonjour
import logging

logger = logging.getLogger('bonjour')

def register_service(name, regtype, port):
    def register_callback(sdRef, flags, errorCode, name, regtype, domain):
        if errorCode == pybonjour.kDNSServiceErr_NoError:
			logger.debug('Registered bonjour service %s.%s', name, regtype)

    service = pybonjour.DNSServiceRegister(name = name,
                                           regtype = regtype,
                                           port = port,
                                           callBack = register_callback)

    try:
        try:
            while True:
                ready = select.select([service], [], [])
                if service in ready[0]:
                    pybonjour.DNSServiceProcessResult(service)
        except KeyboardInterrupt:
            pass
    finally:
        service.close()

