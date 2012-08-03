
PonyDebugger Code Generation
============================

PonyDebugger uses code generation to implement the WebKit Inspector protocol defined in an 
`Inspector.json` file. This file can be retrieved from the official webkit repository. We currently
use a tip-of-the-tree version of the protocol, as it contains IndexedDB domain commands that are
required to implement Core Data browsing. These unversioned protocols are not guaranteed to be backwards 
compatible with other unversioned tip-of-the-tree protocol definitions.

### Usage

```
  go run parser.go parser_types.go < Inspector.json
```

