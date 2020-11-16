import UIKit
import PokedexStyle

/// Pokemon item loading state
enum PokemonLoadingState {
    case loading
    case finished
    case error
}

/// Pokemon item to configure Pokemon cell
struct PokemonItem {
    let id: Int
    let name: String
    var description: String?
    var types: [PokemonType]? = nil
    var image: UIImage? = nil
    var state: PokemonLoadingState
}
