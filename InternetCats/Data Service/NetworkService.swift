//
//  NetworkService.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit

class NetworkService: NetworkServiceType {
    /// Make network calls of any kind
    /// - Parameters:
    ///   - endpoint: Endpoint information about the request
    ///   - completion: Completion action that specifies the decoded response type
    func call<T>(endpoint: EndPointType, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable, T: Encodable {
        guard var validURL = URL(string: endpoint.baseURL) else {
            completion(.failure(ErrorMessage("Invalid URL")))
            return
        }

        validURL.appendPathComponent(endpoint.path)

        if let queryItems = endpoint.queryItems {
            var queryParameters: [URLQueryItem] = []

            for (key, value) in queryItems {
                let q = URLQueryItem(name: key, value: value)
                queryParameters.append(q)
            }

            validURL.append(queryItems: queryParameters)
        }

        var request = URLRequest(url: validURL)
        request.httpMethod = endpoint.httpMethod.rawValue

        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(key, forHTTPHeaderField: value)
            }
        }

        // Set default API query headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = endpoint.body {
            do {
                let httpBody = try JSONEncoder().encode(body)
                request.httpBody = httpBody
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                guard let validData = data, error == nil else {
                    completion(.failure(error!))
                    return
                }

                do {
                    let responseData = try JSONDecoder().decode(T.self, from: validData)
                    completion(.success(responseData))
                } catch let serializationError {
                    completion(.failure(serializationError))
                }
            }
        }.resume()
    }
}
