import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {

    func testPokemonViewModelListForSomethingIDN() {
        // test increased count on each call
        // to be sure its equal to increased value by page
        // e.g. limit per page = 60, request should add to pokemon array 60
        // compare at the end array count and page limit for xctasserttrue
    }

}
