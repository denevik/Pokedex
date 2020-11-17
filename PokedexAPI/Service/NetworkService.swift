public enum ServiceError: Error {
    case request(Error)
    case emptyData
    case invalidURL
    case parseError(Error?)
}

protocol Networking {
    func performRequest<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping (Result<T, ServiceError>) -> Void)
}

class NetworkService: Networking {

    func performRequest(_ url: URL, completion: @escaping (Result<Data, ServiceError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
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

        URLSession.shared.dataTask(with: url) { data, response, error in
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
                completion(.failure(.parseError(error)))
            }
        }.resume()
    }
}
