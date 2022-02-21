//
//  NetworkClient.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation


class NetworkClient {
    func performRequest<T: Decodable>(_ object: T.Type, router: APIRouter, completion: @escaping ((Result<T, Error>) -> Void)) {
        
        var request = URLRequest(url: URL(string: NetworkConstants.baseUrl + router.path)!)
        request.httpMethod = router.method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            do {
                guard let data = data else {return}
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
    }
}
