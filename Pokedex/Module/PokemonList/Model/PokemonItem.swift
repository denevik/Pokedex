import UIKit
import PokedexStyle

/// Pokemon item to configure Pokemon cell
struct PokemonItem {
    let id: Int
    let name: String
    let types: [PokemonType]
    let image: UIImage
}
