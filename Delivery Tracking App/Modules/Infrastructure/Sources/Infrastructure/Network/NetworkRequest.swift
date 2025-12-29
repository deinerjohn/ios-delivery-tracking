//
//  NetworkRequest.swift
//  Infrastructure
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

public protocol NetworkRequest {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

public extension NetworkRequest {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        
        var components = URLComponents(string: endpoint.baseUrl + endpoint.path)
        components?.queryItems = endpoint.queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let composeUrl = components?.url else  {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: composeUrl)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = TimeInterval(30)
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept-Encoding": "gzip;q=1.0, compress;q=0.5",
            "Accept-Language": Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
                let quality = 1.0 - (Double(index) * 0.1)
                return "\(languageCode);q=\(quality)"
            }.joined(separator: ", "),
            "Accept": "application/json"
        ]
        
        let (data, response) = try await URLSession(configuration: configuration).data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return decodedResponse
            } catch DecodingError.keyNotFound(_, let context),
                    DecodingError.valueNotFound(_, let context),
                    DecodingError.typeMismatch(_, let context),
                    DecodingError.dataCorrupted(let context) {
                print(context.debugDescription)
                throw NetworkError.decodeError
            } catch {
                throw NetworkError.decodeError
            }
        default:
            throw NetworkError.unexpectedStatusCode
        }
        
    }
}
