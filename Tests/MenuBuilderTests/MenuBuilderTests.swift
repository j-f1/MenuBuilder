import XCTest
@testable import MenuBuilder

final class MenuBuilderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let menu = NSMenu {
            MenuItem("Hello, world!")
            SeparatorItem()
        }
        XCTAssertEqual(menu.items.count, 2)
        XCTAssertEqual(menu.items[0].title, "Hello, world!")
        XCTAssertTrue(menu.items[1].isSeparatorItem)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
