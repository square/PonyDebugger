
PonyDebugger
============

PonyDebugger is a remote debugging toolset.  It is a client library and gateway
server combination that uses Chrome Developer Tools on your browser to debug
your application's network traffic and managed object contexts.

To use PonyDebugger, you must implement the client in your application and
connect it to the gateway server. There is currently an iOS client and the
gateway server.

 * [PonyDebugger iOS Client](https://github.com/square/PonyDebugger/tree/master/ObjC)
 * [PonyDebugger Gateway Server](https://github.com/square/PonyDebugger/tree/master/ponyd)

PonyDebugger is licensed under the Apache Licence, Version 2.0
(http://www.apache.org/licenses/LICENSE-2.0.html).

Quick Start
-----------

```sh

curl -sk https://cloud.github.com/downloads/square/PonyDebugger/bootstrap-ponyd.py | \
  python - --ponyd-symlink=/usr/local/bin/ponyd ~/Library/PonyDebugger
```

This will install `ponyd` script to `~/Library/PonyDebugger/bin/ponyd` and
attempt to symlink `/usr/local/bin/ponyd` to it. It will also download the
latest chrome dev tools source.

Then start the PonyDebugger gateway server

```sh
ponyd serve --listen-interface=127.0.0.1
```

In your browser, navigate to `http://localhost:9000`. You should see the
PonyGateway lobby. Now you need to integrate the client to your application.

For more detailed instructions, check out the gateway server
[README_ponyd](https://github.com/square/PonyDebugger/blob/master/README_ponyd.rst).

iOS Client Library
------------------

Right now, integrating the iOS client requires a few steps, so you should check
out the iOS Client PonyDebugger
[README](https://github.com/square/PonyDebugger/blob/master/README_iOS.md).

Contributing
------------

Any contributors to the master PonyDebugger repository must sign the
[Individual Contributor License Agreement
(CLA)](https://spreadsheets.google.com/spreadsheet/viewform?formkey=dDViT2xzUHAwRkI3X3k5Z0lQM091OGc6MQ&ndplr=1>).
It's a short form that covers our bases and makes sure you're eligible to
contribute.

When you have a change you'd like to see in the master repository, [send a pull
request](https://github.com/square/PonyDebugger/pulls). Before we merge your
request, we'll make sure you're in the list of people who have signed a CLA.

Some useful links:

- [Chrome Remote Debugging Documentation](https://developers.google.com/chrome-developer-tools/docs/protocol/tot/index)
- [WebKit Inspector Protocol Definition on GitHub](https://github.com/WebKit/webkit/blob/master/Source/WebCore/inspector/Inspector.json)

