public final class PokedexManager {

    public static let shared = PokedexManager()

    private let networkService = NetworkService()

    /// Fetch one pokemon by given name
    /// - Parameters:
    ///   - name: Name for pokemon
    ///   - completion: Closure with the result
    public func fetchPokemon(_ name: String, completion: @escaping (Result<Pokemon, ServiceError>) -> Void) {
        let endpoint = Endpoint<Pokemon>(path: DefaultPathConstants.pokemon + name)

        networkService.performRequest(endpoint) { [weak self] result in

            switch result {
            case .success(let pokemon):

                let group = DispatchGroup()
                var pokemon = pokemon

                // Image
                guard let imageURL = URL(string: pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault ?? "") else {
                    completion(.failure(.invalidURL))
                    return
                }

                group.enter()
                self?.fetchPokemonImage(imageURL) { result in
                    switch result {
                    case .success(let image):
                        pokemon.image = image
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    group.leave()
                }

                // Breed
                guard let breedURL = URL(string: pokemon.species.url) else {
                    completion(.failure(.invalidURL))
                    return
                }
                group.enter()
                self?.fetchPokemonBreed(breedURL) { result in
                    switch result {
                    case .success(let breed):
                        pokemon.breed = breed
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    group.leave()
                }

                group.notify(queue: .global()) {
                    completion(.success(pokemon))
                }

            case .failure(let error):
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
                completion(.failure(error))
            }
        }
    }
}

extension PokedexManager {

    /// Fetch pokemon breed by given url
    /// - Parameters:
    ///   - url: Url to download pokemon image
    ///   - completion: Closure with the result
    func fetchPokemonBreed(_ url: URL, completion: @escaping (Result<Breed, ServiceError>) -> Void) {
        networkService.performRequest(url) { result in

            switch result {
            case .success(let data):
                do {
                    let breed = try JSONDecoder().decode(Breed.self, from: data)
                    completion(.success(breed))
                } catch {
                    completion(.failure(.parseError(error)))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Fetch pokemon image by given url
    /// - Parameters:
    ///   - url: Url to download pokemon image
    ///   - completion: Closure with the result
    func fetchPokemonImage(_ url: URL, completion: @escaping (Result<UIImage, ServiceError>) -> Void) {
        networkService.performRequest(url) { result in

            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else  {
                    return
                }
                completion(.success(image))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
