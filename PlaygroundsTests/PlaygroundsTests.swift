import XCTest
@testable import Playgrounds

final class PlaygroundsTests: XCTestCase {
    func testAppModuleLoads() {
        XCTAssertNotNil(ContentView())
    }
}
