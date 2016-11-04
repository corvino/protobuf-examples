## Protobuf Examples in Objective-C and Swift

The [protobuf source code](https://github.com/google/protobuf) includes
examples in C++, go, and Python,
while
[Google has guides](https://developers.google.com/protocol-buffers/) for
C++, C#, Go, Java, and Python. Protobuf includes support for Objective-C, and [Apple has a plugin](https://github.com/apple/swift-protobuf) for Swift&mdash;but there aren't examples or guides for either language.

This is a simple port of the C++ examples to Swift and Objective-C.

### Protobuf Version

Currently the examples are only for protobuf version 2. I plan to update these to version 3. Soon. In my copious free time.

### Objective-C

There is a Makefile that builds the C++ and Objective-C examples. The
runtime component is build from
the [protobuf source code](https://github.com/google/protobuf), which is
included as a submodule.

There is also an Xcode project, objc.xcodeproj, that has targets for
add_person and list_people.

### Swift

I haven't cracked a simple build formula for Swift so that it can be
build from the Makefile. There is a swift.xcodeproj that has targets for
add_person and list_people.

_Note: I'd love to be able to build this from the command line in a
similar way as I do the Objective-C examples. That is, without using the
swift package manager and associated files and directories. If anyone
has pointers on this, I'd love to hear them._
