import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SilverKit_swiftTests.allTests),
    ]
}
#endif
