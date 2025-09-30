/*
 Copyright (c) 2025 Bell App Lab <apps@bellapplab.com>

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

#if swift(>=5.5)
import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol GloballyIdentifiable {
    associatedtype GlobalID: Hashable
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol UniqueGlobalIDProvider: GloballyIdentifiable {
    @inlinable
    static var uniqueGlobalId: GlobalID { get }
}

@globalActor
public actor WeakGlobalActor: GlobalActor {
    public static let shared: WeakGlobalActor = .init()
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol WeaklyGloballyIdentifiable: AnyObject, GloballyIdentifiable {
    @WeakGlobalActor
    static var weakGlobals: [GlobalID: Weak<Self>] { get set }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension WeaklyGloballyIdentifiable {

    @inline(__always)
    @WeakGlobalActor
    static func weakGlobal(id: GlobalID, default defaultValue: @autoclosure () throws -> Self) async rethrows -> Self {
        weakGlobals.removeWeaks()
        let result = try weakGlobals[id]?.value as? Self ?? defaultValue()
        weakGlobals[id] = ≈result
        return result
    }

}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension WeaklyGloballyIdentifiable where Self: UniqueGlobalIDProvider {

    @inline(__always)
    @WeakGlobalActor
    static func weakGlobal(default defaultValue: @autoclosure () throws -> Self) async rethrows -> Self {
        weakGlobals.removeWeaks()
        let result = try weakGlobals[uniqueGlobalId]?.value as? Self ?? defaultValue()
        weakGlobals[uniqueGlobalId] = ≈result
        return result
    }

}
#endif
