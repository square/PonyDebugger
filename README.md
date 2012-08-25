
PonyDebugger
============

PonyDebugger is a remote debugging toolset.  It is a client library and gateway server combination that uses Chrome Developer Tools on your browser to debug your application's network traffic and managed object contexts.

To use PonyDebugger, you must implement the client in your application and connect it to the gateway server. There is currently an iOS client and the gateway server.

 * [PonyDebugger iOS Client](https://github.com/square/PonyDebugger/tree/master/iOS)
 * [PonyDebugger Gateway Server](https://github.com/square/PonyDebugger/tree/master/ponygateway)

PonyDebugger is licensed under the Apache Licence, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html).

Quick Start
-----------

- First, install PonyGateway. We distributed a PyPI package for your convenience.

```
sudo pip install ponygateway
```

  Alternatively, install in a virtualenv if you do not want to use sudo.

- Download Chrome Developer Tools locally using the `ponydownloader` tool. This will download Chrome Dev Tools in `~/.devtools`. Run the gateway server with `ponygateway`.

```
ponydownloader
ponygateway
```

- In your browser, navigate to `http://localhost:9000`. You should see the PonyGateway lobby. Now you need to integrate the client to your application.

For more detailed instructions, check out the gateway server [README](https://github.com/square/PonyDebugger/tree/master/ponygateway).

iOS Client Library
------------------

Right now, integrating the iOS client requires a few steps, so you should check out the iOS Client PonyDebugger [README](https://github.com/square/PonyDebugger/tree/master/iOS#installing).

Contributing
------------

Any contributors to the master PonyDebugger repository must sign the [Individual Contributor License Agreement (CLA)](https://spreadsheets.google.com/spreadsheet/viewform?formkey=dDViT2xzUHAwRkI3X3k5Z0lQM091OGc6MQ&ndplr=1>).  It's a short form that covers our bases and makes sure you're eligible to contribute.

When you have a change you'd like to see in the master repository, [send a pull request](https://github.com/square/PonyDebugger/pulls). Before we merge your request, we'll make sure you're in the list of people who have signed a CLA.

Some useful links:

- [Chrome Remote Debugging Documentation](https://developers.google.com/chrome-developer-tools/docs/protocol/tot/index)
- [WebKit Inspector Protocol Definition on GitHub](https://github.com/WebKit/webkit/blob/master/Source/WebCore/inspector/Inspector.json)

