![PonyDebugger Logo](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Logo.png)

PonyDebugger
============
[![CI Status](https://travis-ci.org/square/PonyDebugger.svg?branch=master)](https://travis-ci.org/square/PonyDebugger)
[![Version](https://img.shields.io/cocoapods/v/PonyDebugger.svg)](http://cocoadocs.org/docsets/PonyDebugger)
[![License](https://img.shields.io/cocoapods/l/PonyDebugger.svg)](http://cocoadocs.org/docsets/PonyDebugger)
[![Platform](https://img.shields.io/cocoapods/p/PonyDebugger.svg)](http://cocoadocs.org/docsets/PonyDebugger)

PonyDebugger is a remote debugging toolset.  It is a client library and gateway
server combination that uses Chrome Developer Tools on your browser to debug
your application's network traffic and managed object contexts.

To use PonyDebugger, you must implement the client in your application and
connect it to the gateway server. There is currently an iOS client and the
gateway server.

PonyDebugger is licensed under the Apache Licence, Version 2.0
(http://www.apache.org/licenses/LICENSE-2.0.html).

Changes
-------

### v0.4.0 - 2014-08-15

 - Support `NSURLSession` requests for the Network Debugger. (@viteinfinite)
 - New test application that removes the AFNetworking dependency.
   (@viteinfinite)
 - Remove custom base64 implementation with Apple's built-in implementation.
   (@kyleve)
 - Add PodSpec for pulling the git repository directly. (@wlue)

### v0.3.1 - 2014-01-02

 - Fix only building active arch in debug. (@kyleve)
 - Fix view hierarchy debugging with complex key paths. (@ryanolsonk)
 - Fix crash in swizzled exchangeSubviewAtIndex:withSubviewAtIndex:
   (@ryanolsonk)
 - Fix for crash when having a library that looks like a NSURLConnectionDelegate
   (@peterwilli)

### v0.3.0 - 2013-05-01

 - Remote Logging and Introspection (@wlue)
 - Request response pretty printing in Network Debugger (@davidapgar)
 - Minor bug fixes and improvements. (@jerryhjones, @conradev, @ryanolsonk)

### v0.2.1-beta1 - 2013-01-12

 - Bonjour support (@jeanregisser)
 - Memory leak fix (@rwickliffe)

Features
--------

### Network Traffic Debugging

PonyDebugger sends your application's network traffic through
[ponyd](https://github.com/square/PonyDebugger/tree/master/ponyd),
PonyDebugger's proxy server.  You use Inspector's Network tools to debug network
traffic like how you would debug network traffic on a website in Google Chrome.

![PonyDebugger Network Debugging Screenshot](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/NetworkDebugging.png)

PonyDebugger forwards network traffic, and does not sniff network traffic. This
means that traffic sent over a secure protocol (https) is debuggable.

Currently, the iOS client automatically proxies data that is sent via
`NSURLConnection` and `NSURLSession` methods. This means that it will
automatically work with AFNetworking, and other libraries that use
`NSURLConnection` or `NSURLSession` for network requests.

### Core Data Browser

The Core Data browsing feature allows you to register your applcation's
`NSManagedObjectContext`s and browse all of its entities and managed objects.
You browse data from the IndexedDB section in the Resource tab in Chrome
Developer Tools.

![PonyDebugger Core Data Browser Screenshot](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/CoreDataBrowser.png)

These are read-only stores at the moment.  There are plans to implement data
mutation in a future release.

### View Hierarchy Debugging

PonyDebugger displays your application's view hierarchy in the Elements tab of
the Chrome Developer Tools. As you move through the XML tree, the corresponding
views are highlighted in your app. You can edit the displayed attributes (i.e.
frame, alpha, ...) straight from the Elements tab, and you can change which
attributes to display by giving PonyDebugger an array of UIView key paths.
Deleting a node in the elements panel will remove that node from the view
hierarchy. Finally, when a view is highlighted, you can move it or resize it
from the app using pan and pinch gestures.

![PonyDebugger View Hierarchy Debugging Screenshot](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/ViewHierarchyDebugging.png)

An "inspect" mode can be entered by clicking on the magnifying glass in the
lower left corner of the Developer Tools window. In this mode, tapping on a view
in the iOS app will select the corresponding node in the elements panel. You can
also hold and drag your finger around to see the different views highlighted.
When you lift your finger, the highlighted view will be selected in the elements
panel.

Currently only a subset of the actions possible from the elements panel have
been implemented. There is significant room for continued work and improvement,
but the current functionality should prove useful nonetheless.

### Remote Logging

PonyDebugger lets you remotely log text and object dumps via the `PDLog` and
`PDLogObjects` function. This lets you reduce the amount of content being
loggedin `NSLog`, while also allowing you dynamically introspect objects.

![PonyDebugger Remote Login Screenshot](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/RemoteLogging.png)

Introspected objects can be expanded recursively by property. This means that
you don't have to breakpoint and log in GDB or LLDB to introspect an object.

Quick Start
-----------
Prerequisite: Xcode's Command Line Tools must be installed from the "Downloads"
preference pane.

```sh

curl -s https://cloud.github.com/downloads/square/PonyDebugger/bootstrap-ponyd.py | \
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

PonyDebugger iOS Client
=======================

The PonyDebugger iOS client lets you to debug your application's network
requests and track your managed object contexts.

#### Technical

- Requires iOS 5.0 or above
- Uses ARC (Automatic Reference Counting).
- Uses SocketRocket as a WebSocket client.

Installing
----------

#### CocoaPods

[CocoaPods](http://cocoapods.org/) automates 3rd party dependencies in
Objective-C.

Install the ruby gem.

    $ sudo gem install cocoapods
    $ pod setup

> Depending on your Ruby installation, you may not have to run as sudo to
> install the cocoapods gem.

Create a Podfile. You must be running on iOS 5 or above.

    platform :ios, '5.0'
    pod 'PonyDebugger', '~> 0.4.3'

If you would like to use the latest version of PonyDebugger, point to the Github
repository directly.

    pod 'PonyDebugger', :git => 'https://github.com/square/PonyDebugger.git'

Install dependencies.

    $ pod install

When using CocoaPods, you must open the `.xcworkspace` file instead of the
project file when building your project.

#### Manual Installation

- Extract a tarball or zipball of the repository into your project directory.
  If you prefer, you may also add the project as a submodule.  The iOS client
  uses [SocketRocket](https://github.com/square/SocketRocket) as a dependency,
  and it is included as a submodule.

```
cd /path/to/YourApplication
mkdir Frameworks
git submodule add git://github.com/square/PonyDebugger.git Frameworks/PonyDebugger
git submodule update --init --recursive
```

- Add `PonyDebugger/PonyDebugger.xcodeproj` as a subproject.

![PonyDebugger Installing Subproject](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_Subproject.png)

- In your Project Settings, add the PonyDebugger target as a Target Dependency
  in the Build Phases tab.

![PonyDebugger Installing Target Dependencies](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_TargetDependencies.png)

- Link `libPonyDebugger.a`, `libSocketRocket.a`, and the Framework dependencies
  to your project.

![PonyDebugger Installing Link Libraries and Frameworks](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_LinkLibraries.png)

- PonyDebugger and SocketRocket take advantage of Objective C's ability to add
  categories on an object, but this isn't enabled for static libraries by
  default. To enable this, add the `-ObjC` flag to the "Other Linker Flags"
  build setting.

![PonyDebugger Installing Other Linker Flags](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_OtherLinkerFlags.png)

#### Framework Dependencies

Your .app must be linked against the following frameworks/dylibs in addition to
`libPonyDebugger.a` and `libSocketRocket.a`.

- libicucore.dylib
- CFNetwork.framework
- CoreData.framework
- Security.framework
- Foundation.framework

Usage
-----

PonyDebugger's main entry points exist in the `PDDebugger` singleton.

``` objective-c
PDDebugger *debugger = [PDDebugger defaultInstance];
```

To connect automatically to the PonyGateway on your LAN (via Bonjour):

``` objective-c
[debugger autoConnect];
```

Or to open the connection to a specific host, for instance
`ws://localhost:9000/device`:

``` objective-c
[debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
```

To manually close the connection:

``` objective-c
[debugger disconnect];
```

### Network Traffic Debugging

To enable network debugging:

``` objective-c
[debugger enableNetworkTrafficDebugging];
```

PonyDebugger inspects network data by injecting logic into
`NSURLConnectionDelegate` classes. If you want PonyDebugger to automatically
find these classes for you:

``` objective-c
[debugger forwardAllNetworkTraffic];
```

This will swizzle methods from private APIs, so you should ensure that this only
gets invoked in debug builds. To manually specify delegate classes:

``` objective-c
[debugger forwardNetworkTrafficFromDelegateClass:[MyClass class]];
```

These methods should be invoked before the connection is opened.

### Core Data Browser

PonyDebugger also allows you to browse your application's managed objects.
First, enable Core Data debugging:

``` objective-c
[debugger enableCoreDataDebugging];
```

To register a managed object context:

``` objective-c
[debugger addManagedObjectContext:self.managedObjectContext withName:@"My MOC"];
```

### View Hierarchy Debugging

To enable view hierarchy debugging:

``` objective-c
[debugger enableViewHierarchyDebugging];
```

PonyDebugger will inject logic into `UIView` add/remove methods to monitor
changes in the view hierarchy.

You can also set the attributes you want to see in the elements panel by passing
an array of `UIView` key path strings

``` objective-c
[debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
```

PonyDebugger uses KVO to monitor changes in the attributes of all views in the
hierarchy, so the information in the elements panel stays fresh.

### Remote Logging

To enable remote logging:

``` objective-c
[debugger enableRemoteLogging];
```

Example usage:

``` objective-c
PDLog("Hello world!");               // This logs a simple string to the console output.
PDLogObjects(self);                  // This logs an introspectable version of "self" to the console.
PDLogObjects("My object:", object);  // Combination of text and introspectable object.
```

The repository contains a test application to demonstrate PonyDebugger's
capabilities and usage.

### Known Issues / Improvements

 * `CoreData.framework` must be linked, even if you do not use the Core Data
   browsing functionality.
 * iOS 5.1 and below: In certain cases,
   `-[NSURLConnectionDataDelegate connection:willSendRequest:redirectResponse:]` 
   will never get called.  PonyDebugger requires this call to know when the
   request was sent, and will warn you with a workaround that the timestamp is
   inaccurate.

   To fix the timestamp, make sure that `Accept-Encoding` HTTP header in your
   `NSURLRequest` is not set (by default, iOS will set it to `gzip, deflate`,
   which is usually adequate.

   AFNetworking users: if you subclass `AFHTTPClient`, call
   `[self setDefaultHeader:@"Accept-Encoding" value:nil];`.

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

- [Chrome Remote Debugging Documentation](https://developer.chrome.com/devtools/docs/protocol/tot)
- [WebKit Inspector Protocol Definition on GitHub](https://github.com/WebKit/webkit/blob/master/Source/WebCore/inspector/Inspector.json)


