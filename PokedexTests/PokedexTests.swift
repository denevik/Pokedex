import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {

    // We also can use Quick and Nimble for test cuz they are easy to use
    // and also they are way too much flexible in terms of tests
    // But it's in the pods, I'm not using pods atm in this project

    func testPokemonViewModelListForSomethingIDN() {
        // test increased count on each call
        // to be sure its equal to increased value by page
        // e.g. limit per page = 60, request should add to pokemon array 60
        // compare at the end array count and page limit for xctasserttrue
    }

}
