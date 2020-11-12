// MARK: - PokemonList
public struct PokemonList: Codable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [PokemonListItem]
}

// MARK: - Result
public struct PokemonListItem: Codable {
    public var id: Int? {
        guard let pokemonId = url.split(separator: "/").last, let id = Int(pokemonId) else {
            return nil
        }
        return id
    }
    public let name: String
    public let url: String
}
