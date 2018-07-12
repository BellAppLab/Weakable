/*
 Copyright (c) 2018 Bell App Lab <apps@bellapplab.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation


//MARK: - Protocol
/**
 The base protocol describing how a type can hold a weak object.

 ## See Also:
 - `Weak`
 */
public protocol Weakable {
    associatedtype WeakObject: AnyObject
    var object: WeakObject? { get }
}

//MARK: - Main
/**
 This is the main point of contact with Weakable.
 The `Weak` struct holds a weak reference to an object.

 The way you create a `Weak` is:

 ```swift
 //Given a class
 class TestClass {}
 //and an instance of that class
 var aTestObject = TestClass()

 //You can create a Weak like this:
 let weakTestObject = Weak(aTestObject)
 ```

 Then you can access the underlying object by:

 ```swift
 weakTestObject.object
 ```

 The underlying object will be there just as long as some other part of your code holds a strong reference to it.
 Once it is released there, `Weak` will release it too.

 ## See Also:
 - `Operators`
 */
public struct Weak<Object: AnyObject>: Weakable, ExpressibleByNilLiteral, CustomStringConvertible {
    public typealias WeakObject = Object

    public fileprivate(set) weak var object: Object?
    
    public init(_ object: Object? = nil) {
        self.object = object
    }

    public init(nilLiteral: ()) {
        self.init(nil)
    }

    public var description: String {
        return "Weak(\(String(reflecting: object))"
    }
}


//MARK: - Operators
prefix operator ≈
/**
 Shorthand constructor for `Weak`.

 ```swift
 //Given an object
 let object = AwesomeClass()

 //you can create a Weak by either
 let weakObject = Weak(object)

 //or
 let weakObject = ≈object
 ```
 */
public prefix func ≈<T: AnyObject>(rhs: T?) -> Weak<T> {
    return Weak(rhs)
}

postfix operator ≈
/**
 Shorthand accessor for `Weak`.

 ```swift
 //Given a Weak
 let weakObject = ≈object

 //you can access the underlying object by
 weakObject.object

 //or
 weakObject≈
 ```
 */
public postfix func ≈<T: AnyObject>(lhs: Weak<T>) -> Optional<T> {
    return lhs.object
}

postfix operator ≈?
/**
 Shorthand accessor for `Weak`.

 ```swift
 //Given a Weak
 let weakObject = ≈object

 //you can access the underlying object by
 weakObject.object

 //or
 weakObject≈
 ```
 */
public postfix func ≈?<T: AnyObject>(lhs: Weak<T>) -> T? {
    return lhs.object
}

infix operator ≈: AssignmentPrecedence
/**
 Shorthand assignment for `Weak`.

 ```swift
 //Given a Weak
 let weakObject = ≈object

 //you can change the underlying object by
 weakObject.object = anotherObject

 //or
 weakObject ≈ anotherObject
 ```
 */
public func ≈<T: AnyObject>(lhs: inout Weak<T>, rhs: T?) {
    lhs = Weak(rhs)
}

//MARK: - Collections
public extension Array where Element: Weakable {
    /**
     Returns a new array containing only `Weak`s whose objects aren't `nil`.

   - note: This function calls `filter {}` on the array.
           Expected time complexity: `O(n)`.
     */
    public func filterWeaks() -> [Element] {
        return filter({ $0.object != nil })
    }

    /**
     Given an array of `Weak`s, returns a new array containing only the underlying objects that aren't `nil`.

     - note: This function calls `compactMap {}` on the array.
             Expected time complexity: `O(n)`.
     */
    public func compactWeaks() -> [Element.WeakObject] {
        return compactMap({ $0.object })
    }

    /**
     Modifies the array in place, removing the `Weak`s whose objects are `nil`.

     - note: This function calls `filterWeaks()` on the array and sets it on to `self`.
             Expected time complexity: `O(n)`.
     */
    public mutating func removeWeaks() {
        self = filterWeaks()
    }
}

public extension Array where Element: AnyObject {
    /**
     Given an array of objects, creates a new array by wrapping them in `Weak`s.

     - note: This function calls `map {}` on the array.
             Expected time complexity: `O(n)`.
     */
    public func asWeaks() -> [Weak<Element>] {
        return map({ ≈$0 })
    }
}


public extension Dictionary where Value: Weakable {
    /**
     Given a dictionary whose values are `Weak`s, return a new dictionary containing only the `Weak`s whose objects aren't `nil`.

     - note: This function calls `filter {}` on the dictionary.
             Expected time complexity: `O(n)`.
     */
    public func filterWeaks() -> Dictionary<Key, Value> {
        #if swift(>=4.0)
        return filter({ $1.object != nil })
        #else
        var result = Dictionary<Key, Value>()
        forEach({
            if $1.object != nil {
                result[$0] = $1
            }
        })
        return result
        #endif
    }

    /**
     Given a dictionary whose values are `Weak`s, returns a new dictionary containing only the underlying objects that aren't `nil`.

     - note: This function calls `filterWeaks().mapValues {}` on the dictionary.
             Expected time complexity: `O(n)`.
     */
    public func compactWeaks() -> Dictionary<Key, Value.WeakObject> {
        return filterWeaks().mapValues({ $0.object! })
    }

    /**
     Modifies the dictionary in place, removing the `Weak`s whose objects are `nil`.

     - note: This function calls `filterWeaks()` on the array and sets it on to `self`.
             Expected time complexity: `O(n)`.
     */
    public mutating func removeWeaks() {
        self = filterWeaks()
    }
}

public extension Dictionary where Value: AnyObject {
    /**
     Given a dictionary of objects, creates a new dictionary by wrapping them in `Weak`s.

     - note: This function calls `mapValues {}` on the dictionary.
             Expected time complexity: `O(n)`.
     */
    public func asWeakValues() -> Dictionary<Key, Weak<Value>> {
        return mapValues({ ≈$0 })
    }
}


//MARK: - Equatable
/*
 Since @nvzqz "stole" the name Weak for a pod,
 I'm "borrowing" some of his equatable functions
 😜
 In other words, these are based upon: https://github.com/nvzqz/Weak
 */
// Returns a Boolean value indicating whether two weak objects are equal.
public func ==<W: Weakable>(lhs: W?, rhs: W?) -> Bool where W.WeakObject: Equatable {
    return lhs?.object == rhs?.object
}

/// Returns a Boolean value indicating whether a weak object and an optional object are equal.
public func ==<W: Weakable>(lhs: W?, rhs: W.WeakObject?) -> Bool where W.WeakObject: Equatable {
    return lhs?.object == rhs
}

/// Returns a Boolean value indicating whether an optional object and a weak object are equal.
public func ==<W: Weakable>(lhs: W.WeakObject?, rhs: W?) -> Bool where W.WeakObject: Equatable {
    return lhs == rhs?.object
}

// Returns a Boolean value indicating whether two weak objects are not equal.
public func !=<W: Weakable>(lhs: W?, rhs: W?) -> Bool where W.WeakObject: Equatable {
    return lhs?.object != rhs?.object
}

/// Returns a Boolean value indicating whether a weak object and an optional object are not equal.
public func !=<W: Weakable>(lhs: W?, rhs: W.WeakObject?) -> Bool where W.WeakObject: Equatable {
    return lhs?.object != rhs
}

/// Returns a Boolean value indicating whether an optional object and a weak object are not equal.
public func != <W: Weakable>(lhs: W.WeakObject?, rhs: W?) -> Bool where W.WeakObject: Equatable {
    return lhs != rhs?.object
}
