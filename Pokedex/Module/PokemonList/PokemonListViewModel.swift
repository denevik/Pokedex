import UIKit
import PokedexAPI
import PokedexStyle


enum SearchStatus: String {
    case noMatch = "No matches - full name needed"
    case notEnoughLetters = "Provide more letters for search"
    case requestIssue = "Something went wrong"
    case success, emptySearch 
}

protocol PokemonListViewModelDelegate: class {
    func dataSourceDidUpdate()
    func didFinishLoadingPokemon(_ id: Int)
    func searchDidFinish(status: SearchStatus)
}

protocol PokemonListViewModelProtocol: class {
    /// Pokemon List View Model delegate who will notify for any changes inside
    var delegate: PokemonListViewModelDelegate? { get set }

    /// Pokemons
    var pokemonItems: [PokemonItem] { get }

    /// Returns Pokemon object with all details for provided pokemon id
    func pokemonDetails(name: String) -> Pokemon?

    /// Search pokemon by given name
    func searchPokemon(name: String)

    /// Load more pokemons
    func loadMore()
}

class PokemonListViewModel: PokemonListViewModelProtocol {

    // MARK: - PokemonListViewModelProtocol

    weak var delegate: PokemonListViewModelDelegate?
    var pokemonItems: [PokemonItem] {
        return searchPokemon != nil ? [searchPokemon!] : sortedPokemons()
    }

    func pokemonDetails(name: String) -> Pokemon? {
        guard let pokemon = detailedPokemons[name] else {
            print("Wrong pokemon name")
            return nil
        }

        return pokemon
    }

    func searchPokemon(name: String) {
        searchPokemon = nil

        if name.isEmpty {
            delegate?.searchDidFinish(status: .emptySearch)
            return
        }

        if name.count < 3 {
            delegate?.searchDidFinish(status: .notEnoughLetters)
            return
        }

        if !allPokemonNames.contains(name) {
            delegate?.searchDidFinish(status: .noMatch)
            return
        }

        if let pokemon = pokemons.values.first(where: { $0.name == name }) {
            searchPokemon = pokemon
            delegate?.searchDidFinish(status: .success)
            return
        }

        PokedexManager.shared.fetchPokemon(name) { [weak self] result in
            switch result {
            case .success(let pokemon):
                let types = pokemon.types.compactMap { PokemonType(rawValue: $0.type.name) }
                DispatchQueue.main.async {
                    self?.detailedPokemons[pokemon.name] = pokemon
                    self?.searchPokemon = PokemonItem(id: pokemon.id, name: pokemon.name, description: pokemon.description, types: types, image: pokemon.image, state: .finished)
                    self?.delegate?.searchDidFinish(status: .success)
                }

            case .failure(let error):
                print("\(#function) Error during pokemon search request: \(error)")
                DispatchQueue.main.async {
                    self?.delegate?.searchDidFinish(status: .requestIssue)
                }
            }
        }
    }

    func loadMore() {
        currentPage += 1
        load(page: currentPage)
    }

    // MARK: - PokemonListViewModel

    private var pokemons = [Int: PokemonItem]()
    private var allPokemonNames = [String]()
    private var detailedPokemons = [String: Pokemon]()
    private var searchPokemon: PokemonItem?
    private let pageLimit = 60
    private let maximumLimit = 1050
    private var offset: Int {
        pageLimit * (currentPage - 1)
    }
    private var currentPage = 1

    init() {
        load(page: 1)
        downloadAllPokemonNames()
    }

    func load(page: Int) {
        PokedexManager.shared.fetchPokemonList(limit: pageLimit, offset: offset) { [weak self] result in
            switch result {

            case .success(let pokemonList):
                DispatchQueue.main.async {
                    self?.pokemons = pokemonList.results.reduce(self?.pokemons ?? [Int: PokemonItem]()) { dict, next in
                        guard let id = next.id else { return dict }
                        var dict = dict
                        dict[id] = PokemonItem(id: id, name: next.name, state: .loading)
                        return dict
                    }
                    self?.delegate?.dataSourceDidUpdate()
                }

                for pokemonListItem in pokemonList.results {
                    guard let id = pokemonListItem.id else { continue }

                    PokedexManager.shared.fetchPokemon(pokemonListItem.name) { [weak self] result in
                        switch result {
                        case .success(let pokemon):
                            DispatchQueue.main.async {
                                self?.detailedPokemons[pokemon.name] = pokemon
                                let types = pokemon.types.compactMap { PokemonType(rawValue: $0.type.name) }
                                self?.pokemons[id]?.types = types
                                self?.pokemons[id]?.image = pokemon.image
                                self?.pokemons[id]?.description = pokemon.description
                                self?.pokemons[id]?.state = .finished
                                self?.delegate?.didFinishLoadingPokemon(pokemon.id)
                            }

                        case .failure(let error):
                            print("\(#function) - Error while loading pokemon: \(error)")
                        }
                    }
                }

            case .failure(let error):
                print("\(#function) - Error while loading pokemon list: \(error)")
            }
        }
    }
}

private extension PokemonListViewModel {

    func downloadAllPokemonNames() {
        PokedexManager.shared.fetchPokemonList(limit: maximumLimit, offset: 0) { [weak self] result in
            switch result {
            case .success(let pokemonList):
                self?.allPokemonNames = pokemonList.results.map { $0.name }
            case .failure(let error):
                print("\(#function) Error during pokemons download: \(error)")
            }
        }
    }

    func sortedPokemons() -> [PokemonItem] {
        return Array(pokemons.values).sorted { $0.id < $1.id }
    }
}
