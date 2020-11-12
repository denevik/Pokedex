public enum ServiceError: Error {
    case request(Error)
    case emptyData
    case invalidURL
    case parseError(Error)
}

protocol Networking {
    func performRequest<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, ServiceError>) -> Void)
}

class NetworkService: Networking {

    // This has to be done with an Operations + Queues
    // It would be way more better and stable solution
    // but since I'm in the bounds of time I have to use a simple one ¯\_(ツ)_/¯
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 350
        return URLSession(configuration: configuration)
    }()

    func performRequest(_ url: URL, completion: @escaping (Result<Data, ServiceError>) -> Void) {
        urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.request(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }

            completion(.success(data))
        }.resume()
    }

    func performRequest<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, ServiceError>) -> Void) {

        guard let url = endpoint.url else {
            return completion(.failure(.invalidURL))
        }

        urlSession.dataTask(with: url) { data, _, error in
            do {

                if let error = error {
                    completion(.failure(.request(error)))
                    return
                }

                guard let data = data else {
                    completion(.failure(.emptyData))
                    return
                }

                let result = try JSONDecoder().decode(T.self, from: data)

                completion(.success(result))
            } catch {
                print("\(#function) - Error on parse: \(error)")
                completion(.failure(.parseError(error)))
            }
        }.resume()
    }
}