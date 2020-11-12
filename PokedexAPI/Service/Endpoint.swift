// MARK: - Endpoint Constants

fileprivate struct URLConstants {
    static let scheme = "https"
    static let host = "pokeapi.co"
    static let startPath = "/api/"
}

public struct DefaultPathConstants {
    static let pokemon = "/pokemon/"
    static let ability = "/ability/"
    static let type = "/type/"
    static let limit = "limit"
    static let offset = "offset"
}

// MARK: - API versions

enum APIVersion: String {
    case v2 = "v2"
}

// MARK: - Endpoint

struct Endpoint<T> {
    let path: String
    let queryItems: [URLQueryItem]

    init(path: String) {
        self.init(path: path, queryItems: [])
    }

    init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }
}

extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = URLConstants.scheme
        components.host = URLConstants.host
        components.path = URLConstants.startPath + APIVersion.v2.rawValue + path
        components.queryItems = queryItems

        return components.url
    }
}
