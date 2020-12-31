import XCTest
@testable import MenuBuilder

final class MenuBuilderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MenuBuilder().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
