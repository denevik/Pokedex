import XCTest

class PokedexUITests: XCTestCase {

    func testPokemonCellForWrongItemData() {
        // do something on cell configure
        // make XCAssertTrue or false with message
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
