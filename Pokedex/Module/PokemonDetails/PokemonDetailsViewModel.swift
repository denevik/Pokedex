import PokedexAPI
import PokedexStyle

protocol PokemonDetailsViewModelProtocol {

    /// Pokemon with all details
    var pokemon: Pokemon { get }

    /// Pokemon type, e.g. Fire, Poison, Water etc
    var pokemonTypes: [PokemonType] { get }
}

class PokemonDetailsViewModel: PokemonDetailsViewModelProtocol {

    var pokemon: Pokemon
    var pokemonTypes: [PokemonType] {
        return pokemon.types.compactMap { PokemonType(rawValue: $0.type.name) }
    }

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
