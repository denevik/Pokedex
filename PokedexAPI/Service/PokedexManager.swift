public final class PokedexManager {

    public static let shared = PokedexManager()

    private let networkService = NetworkService()

    /// Fetch pokemon image by given url
    /// - Parameters:
    ///   - url: Url to download pokemon image
    ///   - completion: Closure with the result
    public func fetchPokemonImage(_ url: URL, completion: @escaping (Result<UIImage, ServiceError>) -> Void) {
        networkService.performRequest(url) { result in

            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else  {
                    print("\(#function) - Error on getting image from data")
                    return
                }
                completion(.success(image))

            case .failure(let error):
                print("\(#function) - Error during request: \(error)")
                completion(.failure(error))
            }
        }
    }

    /// Fetch one pokemon by given name
    /// - Parameters:
    ///   - name: Name for pokemon
    ///   - completion: Closure with the result
    public func fetchPokemon(_ name: String, completion: @escaping (Result<Pokemon, ServiceError>) -> Void) {
        let endpoint = Endpoint<Pokemon>(path: DefaultPathConstants.pokemon + name)

        networkService.performRequest(endpoint) { result in

            switch result {
            case .success(let pokemon):
                completion(.success(pokemon))

            case .failure(let error):
                print("\(#function) - Error during request: \(error)")
                completion(.failure(error))
            }
        }
    }

    /// Fetch pokemons list within provided page, limit and offset.
    /// - Parameters:
    ///   - limit: The Pokemons limit per page
    ///   - offset: Offset for the current page
    ///   - completion: Closure with the result
    public func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, ServiceError>) -> Void) {
        let queryItems = [
            URLQueryItem(name: DefaultPathConstants.limit, value: String(limit)),
            URLQueryItem(name: DefaultPathConstants.offset, value: String(offset))
        ]

        let endpoint = Endpoint<PokemonList>(path: DefaultPathConstants.pokemon, queryItems: queryItems)

        networkService.performRequest(endpoint) { result in
            switch result {

            case .success(let pokemonList):
                completion(.success(pokemonList))

            case .failure(let error):
                print("\(#function) - Error during request: \(error)")
                completion(.failure(error))
            }
        }
    }
}
