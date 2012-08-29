
PonyGateway: PonyDebugger Gateway Server
========================================

This directory contains the gateway server that serves Chrome Developer Tools.

PonyGateway is licensed under the Apache Licence, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html).

Installing
----------

- To install the latest stable version:

  ``sudo pip install ponygateway``

  Or omit sudo if installing in a virtual environment.

  **Note**: If you want to download the latest version, you will have to clone the repository and run ``sudo python setup.py install`` in the ``ponygateway`` directory.

- Install a supported version of Chrome Developer Tools with ``ponydownloader``.

  This will install a supported version of Chrome Developer Tools into ``~/.devtools`` by default. To specify a custom directory:

  ``ponydownloader /path/to/devtools``

- To run the Gateway server, run ``ponygateway``. By default, this will run the 
  gateway on ``localhost:9000``.  
  
  To specify a custom devtools directory:

  ``ponygateway -d /path/to/devtools``

  For more details, run ``ponygateway -h``

Known Issues / Improvements
---------------------------

- Relaunching the client application requires you to navigate back to the main page.
- Chrome Developer Tools shows some unnecessary tabs (such as Elements).  ``ponydownloader`` could possibly be
  updated to patch the incoming chrome developer tools to hide these unused tabs.

