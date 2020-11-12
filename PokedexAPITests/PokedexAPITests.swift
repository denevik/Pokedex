import XCTest
@testable import PokedexAPI

class PokedexAPITests: XCTestCase {

    // We also can use Quick and Nimble for test cuz they are easy to use
    // and also they are way too much flexible in terms of tests
    // But it's in the pods, I'm not using pods atm in this project

    func testPokemonRequestWithWrongURLEndpoint() {
        // make endpoint with invalid URL
        // call pokedex service with invalid endpoint
        //
        // XCTAssertFalse(pokedexService.fetch, "Wrong URL did pass somehow.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
