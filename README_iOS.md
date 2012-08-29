
PonyDebugger iOS Client
=======================

The PonyDebugger iOS client lets you to debug your application's network requests and track your managed object contexts.

#### Technical

- Requires iOS 5.0 or above
- Uses ARC (Automatic Reference Counting).
- Uses SocketRocket as a WebSocket client.

<img src="https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Logo.png" width="120" />

Features
--------

### Network Traffic Debugging

PonyDebugger sends your application's network traffic through a [PonyGateway](https://github.com/square/PonyDebugger/tree/master/ponygateway) proxy server.  You use Inspector's Network tools to debug network traffic like how you would debug network traffic on a website in Google Chrome.

![PonyDebugger Network Debugging Screenshot](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/NetworkDebugging.png)

PonyDebugger forwards network traffic, and does not sniff network traffic.  This means that traffic sent over a secure protocol (https) is debuggable.

Currently, the iOS client automatically proxies data that is sent via `NSURLConnection`.  This means that it will automatically work with AFNetworking, and other libraries that use `NSURLConnection` for network requests.

### Core Data Browser

The Core Data browsing feature allows you to register your applcation's `NSManagedObjectContext`s and browse all of its entities and managed objects.  You browse data from the IndexedDB section in the Resource tab in Chrome Developer Tools.

![PonyDebugger Core Data Browser Screenshot](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/CoreDataBrowser.png)

These are read-only stores at the moment.  There are plans to implement data mutation in a future release.

Installing
----------

- Extract a tarball or zipball of the repository into your project directory.  If you prefer, you may also add the project
  as a submodule.  The iOS client uses [SocketRocket](https://github.com/square/SocketRocket) as a dependency, and it is included as a 
  submodule.
      
```
cd /path/to/YourApplication
mkdir Frameworks
git submodule add git://github.com/square/PonyDebugger.git Frameworks/PonyDebugger
git submodule update --init --recursive
```

- Add `PonyDebugger/PonyDebugger.xcodeproj` as a subproject.

![PonyDebugger Installing Subproject](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_Subproject.png)

- In your Project Settings, add the PonyDebugger target as a Target Dependency in the Build Phases tab.

![PonyDebugger Installing Target Dependencies](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_TargetDependencies.png)

- Link `libPonyDebugger.a`, `libSocketRocket.a`, and the Framework dependencies to your project.

![PonyDebugger Installing Link Libraries and Frameworks](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_LinkLibraries.png)

- In your project's Build Settings, add `$(CONFIGURATION_BUILD_DIR)/usr/local/include` as a non-recursive Header Search Path.

![PonyDebugger Installing Header Search Path](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_HeaderSearchPath.png)

- PonyDebugger and SocketRocket take advantage of Objective C's ability to add categories on an object, but this isn't enabled for static libraries by default. To enable this, add the `-ObjC` flag to the "Other Linker Flags" build setting.

![PonyDebugger Installing Other Linker Flags](https://github.com/square/PonyDebugger/raw/master/Documentation/Images/Installing_OtherLinkerFlags.png)

#### Framework Dependencies

Your .app must be linked against the following frameworks/dylibs in addition to `libPonyDebugger.a` and `libSocketRocket.a`.

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

To open the connection to `ws://localhost:9000/device`:

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

PonyDebugger inspects network data by injecting logic into `NSURLConnectionDelegate` classes. If you want PonyDebugger to automatically find these classes for you:

``` objective-c
[debugger forwardAllNetworkTraffic];
```

This will swizzle methods from private APIs, so you should ensure that this only gets invoked 
in debug builds.  To manually specify delegate classes:

``` objective-c
[debugger forwardNetworkTrafficFromDelegateClass:[MyClass class]];
```

These methods should be invoked before the connection is opened.

### Core Data Browser

PonyDebugger also allows you to browse your application's managed objects. First, enable Core Data debugging:

``` objective-c
[debugger enableCoreDataDebugging];
```

To register a managed object context:

``` objective-c
[debugger addManagedObjectContext:self.managedObjectContext withName:@"My MOC"];
```

The repository contains a test application to demonstrate PonyDebugger's capabilities and usage.

Known Issues / Improvements
---------------------------

 * `CoreData.framework` must be linked, even if you do not use the Core Data browsing functionality.

