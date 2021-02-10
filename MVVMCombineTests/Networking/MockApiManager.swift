//
//  MockApiManager.swift
//  MVVMCombineTests
//
//  Created by Victor Roldan on 9/02/21.
//

@testable import MVVMCombine
import Foundation
import Combine


class MockApiManager : APIManagerDelegate{
    
    
    func fetchItems<T: Codable>(endpoint: Endpoint, completion : @escaping (Result<T, Error>) -> Void){
        //let url = URL(string: endpoint.urlString)!
        var resourceFileName = "users"
        if endpoint == .usersFetchMock{
            resourceFileName = "fakeName"
        }else if (endpoint == .getUserById(id: "1")){
            resourceFileName = "user"//singular
            
        }
        if let url = Bundle.main.url(forResource: resourceFileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                completion(.success(jsonData))
            } catch {
                completion(.failure(errorMessage.basicError))
                print("error:\(error)")
            }
        }else{
            completion(.failure(errorMessage.basicError))
        }
    }
    
}
