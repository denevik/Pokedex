import UIKit
import PokedexAPI
import PokedexStyle

protocol PokemonListViewModelDelegate: class {
    func didFinishPageLoading()
    func filterDidUpdate()
}

protocol PokemonListViewModelProtocol: class {
    /// Pokemon List View Model delegate who will notify for any changes inside
    var delegate: PokemonListViewModelDelegate? { get set }

    /// Pokemons
    var pokemonItems: [PokemonItem] { get }

    /// Filter pokemon from given string on search bar
    var filter: String { get set }

    /// Returns Pokemon object with all details for provided pokemon id
    func pokemonDetails(name: String) -> Pokemon?

    /// Load more pokemons
    func loadMore()
}

class PokemonListViewModel: PokemonListViewModelProtocol {

    // MARK: - PokemonListViewModelProtocol

    weak var delegate: PokemonListViewModelDelegate?
    var pokemonItems: [PokemonItem] {
        return filter.isEmpty ? pokemons : filteredPokemonItems()
    }

    var filter: String = "" {
        didSet {
            delegate?.filterDidUpdate()
        }
    }

    func pokemonDetails(name: String) -> Pokemon? {
        guard let pokemon = detailedPokemons[name] else {
            print("Wrong pokemon name")
            return nil
        }

        return pokemon
    }

    func loadMore() {
        currentPage += 1
        load(page: currentPage)
    }

    // MARK: - PokemonListViewModel
    private var pokemons = [PokemonItem]()
    private var detailedPokemons = [String: Pokemon]()
    private let pageLimit = 150
    private var offset: Int {
        pageLimit * (currentPage - 1)
    }
    private var currentPage = 1

    init() {
        load(page: 1)
    }

    func load(page: Int) {
        PokedexManager.shared.fetchPokemonList(limit: pageLimit, offset: offset) { [weak self] result in
            switch result {

            case .success(let responsePokemonList):

                let dispatchGroup = DispatchGroup()
                responsePokemonList.results.forEach { pokemonListItem in

                    dispatchGroup.enter()
                    PokedexManager.shared.fetchPokemon(pokemonListItem.name) { [weak self] result in
                        switch result {
                        case .success(let pokemon):
                            self?.detailedPokemons[pokemon.name] = pokemon
                            self?.addPokemonItem(pokemon, on: dispatchGroup)
                        case .failure(let error):
                            print("\(#function) - Error while loading pokemon: \(error)")
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self?.sortPokemons()
                    self?.delegate?.didFinishPageLoading()
                }

            case .failure(let error):
                print("\(#function) - Error while loading pokemon: \(error)")
            }
        }
    }
}

private extension PokemonListViewModel {

    func addPokemonItem(_ pokemon: Pokemon, on dispatchGroup: DispatchGroup) {
        guard let url = URL(string: pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault ?? "") else {
            print("\(#function) - No string url for pokemon image")
            return
        }

        // Load image for pokemon
        PokedexManager.shared.fetchPokemonImage(url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    let types = pokemon.types.compactMap { PokemonType(rawValue: $0.type.name) }
                    let pokemonItem = PokemonItem(id: pokemon.id, name: pokemon.name, types: types, image: image)
                    self?.pokemons.append(pokemonItem)

                case .failure(let error):
                    print("\(#function) - Error while loading pokemon: \(error)")
                }
                dispatchGroup.leave()
            }
        }
    }

    func filteredPokemonItems() -> [PokemonItem] {
        return pokemons.filter { $0.name.lowercased().contains(filter.lowercased()) }
    }

    func sortPokemons() {
        pokemons = pokemons.sorted { $0.id < $1.id }
    }

}
