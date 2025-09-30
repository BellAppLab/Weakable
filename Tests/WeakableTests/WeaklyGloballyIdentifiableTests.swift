import XCTest
@testable import Weakable

#if swift(>=5.5)
private final class TestObject: Identifiable, WeaklyGloballyIdentifiable, Equatable {
    static func == (lhs: TestObject, rhs: TestObject) -> Bool {
        lhs.id == rhs.id
    }

    typealias GlobalID = ID

    @WeakGlobalActor
    static var weakGlobals: [GlobalID: Weak<TestObject>] = [:]

    let id: Int

    init(id: Int) {
        self.id = id
    }
}

private final class TestUniqueObject: Identifiable, WeaklyGloballyIdentifiable, UniqueGlobalIDProvider, Equatable {

    static func == (lhs: TestUniqueObject, rhs: TestUniqueObject) -> Bool {
        lhs.id == rhs.id
    }

    typealias GlobalID = ID
    static var uniqueGlobalId: ID { 0 }

    @WeakGlobalActor
    static var weakGlobals: [GlobalID: Weak<TestUniqueObject>] = [:]

    let id: Int

    init() {
        id = Self.uniqueGlobalId
    }
}

final class GloballyIdentifiableTests: XCTestCase {

    @WeakGlobalActor
    func testThatWeaklyGloballyIdentifiableObjectsAreReleased() async {
        var id = 0
        var testObject1: TestObject? = await .weakGlobal(id: id, default: .init(id: id))

        // The weakGlobals dictionary should contain one element while the
        // testObject1 variable is not nil
        XCTAssertEqual(TestObject.weakGlobals.count, 1, "\(TestObject.weakGlobals)")
        XCTAssertNotNil(TestObject.weakGlobals.first?.value.value as? TestObject)
        XCTAssertNotNil(testObject1)
        XCTAssertEqual(TestObject.weakGlobals.first?.value.value as? TestObject, testObject1)

        var testObject2: TestObject? = await .weakGlobal(id: id, default: .init(id: id))

        // Trying to create another test object using the same id as an existing
        // weak global should return the same object as before
        XCTAssertEqual(TestObject.weakGlobals.count, 1, "\(TestObject.weakGlobals)")
        XCTAssertNotNil(testObject2)
        XCTAssertEqual(testObject1, testObject2)
        // They should not only have the same id, but also have the same memory reference
        XCTAssertTrue(testObject1 === testObject2)

        // Creating a second object
        id = 1
        testObject2 = await .weakGlobal(id: id, default: .init(id: id))

        XCTAssertEqual(TestObject.weakGlobals.count, 2, "\(TestObject.weakGlobals)")
        XCTAssertNotNil(testObject2)
        XCTAssertNotEqual(testObject1, testObject2)
        XCTAssertFalse(testObject1 === testObject2)

        // Deleting objects
        testObject1 = nil
        testObject2 = await .weakGlobal(id: id, default: .init(id: id))
        // The weakGlobals dictionary has been flattened
        XCTAssertEqual(TestObject.weakGlobals.count, 1, "\(TestObject.weakGlobals)")
        XCTAssertEqual(TestObject.weakGlobals.first?.value.value as? TestObject, testObject2)
    }

    @WeakGlobalActor
    func testThatWeaklyGloballyIdentifiableAndUniqueGlobalIDProviderRetunsTheSameObject() async {
        var testObject1: TestUniqueObject? = await .weakGlobal(default: .init())

        // The weakGlobals dictionary should contain one element while the
        // testObject1 variable is not nil
        XCTAssertEqual(TestUniqueObject.weakGlobals.count, 1, "\(TestUniqueObject.weakGlobals)")
        XCTAssertNotNil(TestUniqueObject.weakGlobals.first?.value.value as? TestUniqueObject)
        XCTAssertNotNil(testObject1)
        XCTAssertEqual(TestUniqueObject.weakGlobals.first?.value.value as? TestUniqueObject, testObject1)

        var testObject2: TestUniqueObject? = await .weakGlobal(id: 0, default: .init())

        // Trying to create another test object using the same id as an existing
        // weak global should return the same object as before
        // even if we pass a different id
        XCTAssertEqual(TestUniqueObject.weakGlobals.count, 1, "\(TestUniqueObject.weakGlobals)")
        XCTAssertNotNil(testObject2)
        XCTAssertEqual(testObject1, testObject2)
        // They should not only have the same id, but also have the same memory reference
        XCTAssertTrue(testObject1 === testObject2)

        // Deleting objects
        testObject1 = nil
        testObject2 = nil
        TestUniqueObject.weakGlobals.removeWeaks()
        XCTAssertEqual(TestUniqueObject.weakGlobals.count, 0, "\(TestUniqueObject.weakGlobals)")
    }

}
#endif
