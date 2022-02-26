//
//  NetworkClient.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import UIKit

class NetworkClient {
    
    var task: URLSessionTask?
    
    func performRequest<T: Decodable>(_ object: T.Type, router: APIRouter, completion: @escaping ((Result<T, Error>) -> Void)) {
        let accessKey = URLQueryItem(name: "access_key", value: "b78c68db5b26b8d60b929760a670f5ab")
        guard var urlComponents = URLComponents(string: NetworkConstants.baseUrl + router.path) else {return}
        urlComponents.queryItems = [accessKey]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = router.method.rawValue

        task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            do {
                guard let data = data else {return}
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task!.resume()
        
    }
    
    func cancelRequests() {
        task!.cancel()
    }
}
