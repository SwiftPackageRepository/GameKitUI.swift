import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GameKitUI_Tests.allTests),
    ]
}
#endif
