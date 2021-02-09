//
//  APIManager.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 26/01/21.
//

import Foundation
import Combine

protocol ServiceLayerProtocol {
    var cancellable : Set<AnyCancellable> {get}
    func fetchItems<T: Codable>(url : URL, completion : @escaping (Result<T, Error>) -> Void)
}

enum errorMessage : Error {
    case basicError
}

enum Endpoint {
    static let url = "https://jsonplaceholder.typicode.com/"
    case usersFetch
    case getUserById(id : String)
    
    var urlString : String{
        switch self {
        case .usersFetch:
            return Endpoint.url+"users"
            
        case .getUserById(let userId):
            return Endpoint.url+"users/"+userId
        }
    }
}

class APIManager{
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchItems<T: Codable>(url : URL, completion : @escaping (Result<T, Error>) -> Void){
        URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink {  resultCompletion in
                switch resultCompletion{
                case .failure(let error):
                    completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { resultArray in
                completion(.success(resultArray))
            }
            .store(in: &cancellable)
    }
    
    
}
