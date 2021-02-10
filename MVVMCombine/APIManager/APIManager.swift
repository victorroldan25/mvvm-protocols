//
//  APIManager.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 26/01/21.
//

import Foundation
import Combine

enum errorMessage : Error {
    case basicError
}

enum Endpoint : Equatable{
    static let url = "https://jsonplaceholder.typicode.com/"
    case usersFetch
    case getUserById(id : String)
    case usersFetchMock
    var urlString : String{
        switch self {
        case .usersFetch:
            return Endpoint.url+"users"
        case .usersFetchMock:
            return Endpoint.url
        case .getUserById(let userId):
            return Endpoint.url+"users/"+userId
        }
    }
}

protocol APIManagerDelegate{
    func fetchItems<T: Codable>(endpoint: Endpoint, completion : @escaping (Result<T, Error>) -> Void)
}

class APIManager : APIManagerDelegate{
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchItems<T: Codable>(endpoint: Endpoint, completion : @escaping (Result<T, Error>) -> Void){
        let url = URL(string: endpoint.urlString)!
        
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
