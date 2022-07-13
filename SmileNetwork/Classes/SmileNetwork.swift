//
//  SmileNetwork.swift
//  SmileNetwork
//
//  Created by laziestlee on 2022/7/12.
//

import Foundation

public protocol SmileNetwork {
    func sendRequest<T: Decodable>(endPoint: SmileEndpoint, responseType: T.Type) async -> Result<T, SmileNetworkError>
}

public extension SmileNetwork {
    func sendRequest<T>(endPoint: SmileEndpoint, responseType: T.Type) async -> Result<T, SmileNetworkError> where T: Decodable {
        let result: Result<T, SmileNetworkError> = await withUnsafeContinuation { continuation in
            guard let request = setupRequest(endPoint: endPoint) else {
                continuation.resume(returning: Result.failure(.invalidURL))
                return
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, _ in
                guard let response = response as? HTTPURLResponse,
                      let data = data else {
                    continuation.resume(returning: Result.failure(.decode))
                    return
                }
                switch response.statusCode {
                case 200 ... 299:
                    guard let decodedResponse = try? JSONDecoder().decode(responseType, from: data) else {
                        continuation.resume(returning: Result.failure(.decode))
                        return
                    }
                    continuation.resume(returning: Result.success(decodedResponse))
                case 401:
                    continuation.resume(returning: Result.failure(.unauthorized))
                default:
                    continuation.resume(returning: Result.failure(.unknown))
                }
            }
            task.resume()
        }
        return result
    }
}

extension SmileNetwork {
    private func setupRequest(endPoint: SmileEndpoint) -> URLRequest? {
        let urlString = endPoint.baseURL + endPoint.path
        var url: URL? = URL(string: urlString)
        if let queryParam = endPoint.queryParams {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryParam.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            url = components?.url
        }
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = endPoint.header
        request.httpMethod = endPoint.method.rawValue
        if let body = endPoint.body, endPoint.method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        return request
    }
}
