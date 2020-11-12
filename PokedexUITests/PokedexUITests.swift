import XCTest

class PokedexUITests: XCTestCase {

    // We also can use Quick and Nimble for test cuz they are easy to use
    // and also they are way too much flexible in terms of tests
    // But it's in the pods, I'm not using pods atm in this project

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
