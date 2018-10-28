# Weakable [![Version](https://img.shields.io/badge/Version-1.0.1-black.svg?style=flat)](#installation) [![License](https://img.shields.io/cocoapods/l/Weakable.svg?style=flat)](#license)

[![Platforms](https://img.shields.io/badge/Platforms-iOS|watchOS|tvOS|macOS|Linux-brightgreen.svg?style=flat)](#installation)
[![Swift support](https://img.shields.io/badge/Swift-3.3%20%7C%204.1%20%7C%204.2-red.svg?style=flat)](#swift-versions-support)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Weakable.svg?style=flat&label=CocoaPods)](https://cocoapods.org/pods/Weakable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Twitter](https://img.shields.io/badge/Twitter-@BellAppLab-blue.svg?style=flat)](http://twitter.com/BellAppLab)

![Weakable](./Images/weakable.png)

Weakable is an easy way to hold `weak` references in Swift.

With Weakable you can create weak arrays, weak dictionaries and many other cool things.

😎

## Requirements

* iOS 9+
* watchOS 3+
* tvOS 9+
* macOS 10.11+
* Swift 3.3+

## Usage

Declare your `Weak` variable in one of the two ways provided:

```swift
//Given a class
class TestClass {}
//and an instance of that class
var aTestObject = TestClass()

//You can create a Weak like this:
var weakTestObject = Weak(aTestObject)

//Or using the shorthand operator ≈
var anotherWeakTestObject = ≈test
```

Access your variable:

```swift
weakTestObject.object //returns your value as an optional, since it may or may not have been released
```

## Operators

`Weakable` comes with 3 operators, all using the `≈` character (**⌥ + x**).

* `prefix ≈`
  * Shorthand contructor for a `Weak` variable:

```swift
//Given an object
let object = AwesomeClass()

//you can create a Weak by either
var weakObject = Weak(object)

//or
var weakObject = ≈object
```

* `postfix operator ≈`
  * Shorthand accessor for `Weak`:
  
```swift
//Given a Weak
var weakObject = ≈object

//you can access the underlying object by
weakObject.object

//or
weakObject≈
```

* `infix operator ≈`
  * Shorthand assignment for `Weak`:
  
```swift
//Given a Weak
var weakObject = ≈object

//you can change the underlying object by
weakObject.object = anotherObject

//or
weakObject ≈ anotherObject
```
    
## Arrays and Dictionaries

You can safely store your `Weak` variables in collections (eg. `[Weak<TestClass>]`). The underlaying objects won't be retained.

```swift
var tests = (1...10).map { TestClass() } // 10 elements
var weakTests = tests.map { ≈$0 } // 10 elements

tests.removeLast() // `tests` now have 9 elements, but `weakTests` have 10

weakTests = weakTests.filterWeaks() // `weakTests` now have 9 elements too, since we dropped the released objects from it
```

You can also quickly "unwrap" the elements in a `Weak` collection:

```swift
let tests = weakTests.compactWeaks()
```

The variable `tests` will now be a `[TestClass]` containing only the elements that haven't been released yet.

## Installation

### Cocoapods

```ruby
pod 'Weakable', '~> 1.0'
```

Then `import Weakable` where needed.

### Carthage

```swift
github "BellAppLab/Weakable" ~> 1.0
```

Then `import Weakable` where needed.

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/BellAppLab/Weakable", from: "1.0")
]
```

Then `import Weakable` where needed.

### Git Submodules

```
cd toYourProjectsFolder
git submodule add -b submodule --name Weakable https://github.com/BellAppLab/Weakable.git
```

Then drag the `Weakable` folder into your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

### Credits

[Logo image](https://thenounproject.com/search/?q=weak&i=37722#) by [Артур Абт](https://thenounproject.com/Abt) from [The Noun Project](https://thenounproject.com/)

## License

Weakable is available under the MIT license. See the LICENSE file for more info.
