import XCTest
@testable import Weakable


class Test: CustomStringConvertible {
    var description: String {
        return "TEST"
    }
}

class TestWithString: CustomStringConvertible {
    private let _description: String
    
    init(description: String) {
        _description = description
    }
    
    var description: String {
        return _description
    }
}


protocol TestProtocol: AnyObject {
}


class OtherTest: TestProtocol, CustomStringConvertible {
    var description: String {
        return "OTHER TEST"
    }
}


class WeakableTests: XCTestCase
{
    func testExample() {
        var test: Test? = Test()
        let weakTest = ≈test
        
        XCTAssertNotNil(weakTest≈, "Underlaying weak value shouldn't be nil")
        XCTAssertEqual(weakTest.object?.description, "TEST", "A Test object should print out TEST")
        
        test = nil
        
        XCTAssertNil(weakTest.object, "Underalying weak value should be nil")
    }
    
    func testAnySequence() {
        var tests = (1...10).map { TestWithString(description: "TEST \($0)") }
        
        let testsCount = tests.count
        
        let strings = ["TEST 1", "TEST 2", "TEST 3", "TEST 4", "TEST 5", "TEST 6", "TEST 7", "TEST 8", "TEST 9", "TEST 10"]
        XCTAssertEqual(strings.count, tests.count, "Both the 'tests' array and the 'strings' array should have the same number of elements")
        
        var tempStrings = strings
        var tempTests = tests
        while !tempStrings.isEmpty {
            let string = tempStrings.removeLast()
            tempTests = tempTests.filter { $0.description != string }
        }
        XCTAssertEqual(tempStrings.count, tempTests.count, "Both the 'tests' array and the 'strings' array should have the same number of elements")
        XCTAssertEqual(tempStrings.count, 0, "The 'tempStrings' array should have zero elements")
        XCTAssertEqual(tempTests.count, 0, "The 'tempTests' array should have zero elements")
        
        var weakTests = tests.asWeaks()
        
        XCTAssertEqual(tests.count, weakTests.count, "Both the 'tests' array and the 'weakTests' array should have the same number of elements")
        
        tests.removeLast()
        
        XCTAssertEqual(tests.count, testsCount - 1, "The 'tests' array should have one less element")
        XCTAssertEqual(weakTests.count, testsCount, "The 'weakTests' array shouldn't have changed")
        
        weakTests = weakTests.filterWeaks()
        
        XCTAssertEqual(weakTests.count, testsCount - 1, "The flattened 'weakTests' array should have one less element")
    }
    
    func testProtocol() {
        var test: OtherTest? = OtherTest()
        let weakTest = ≈test
        
        XCTAssertNotNil(weakTest≈, "Underlaying weak value shouldn't be nil")
        XCTAssertEqual(weakTest.object?.description, "OTHER TEST", "A Test object should print out TEST")
        
        test = nil
        
        XCTAssertNil(weakTest.object, "Underalying weak value should be nil")

        //TODO: fix this
        test = OtherTest()

        var otherWeakTest: Weak<TestProtocol> = nil
        otherWeakTest ≈ test
    }
}

extension WeakableTests
{
  static var allTests : [(String, (WeakableTests) -> () throws -> Swift.Void)] {
    return [
      ("testExample", testExample),
      ("testAnySequence", testAnySequence),
      ("testProtocol", testProtocol)
    ]
  }
}
