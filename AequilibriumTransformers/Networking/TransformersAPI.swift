//
//  TransformersAPI.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import Foundation

/**
 Custom error used for custom error messages from `TransformersAPI`
 */
struct TransformersError: LocalizedError {
    var title: String
}

/**
 Helper struct for `TransformersAPI` allowing simplified parsing of array data from the API
 */
struct TransformersResponse: Codable {
    var transformers: [Transformer]
}

/**
 Class responsible for handling transformers API. Implements `TransformerDataSource`.
 Only protocol methods are public. Token generation and persistance is handled inside of the class.
 */
class TransformersAPI: TransformersDataSource {
    private static let apiURLString = "https://transformers-api.firebaseapp.com"
    private static var apiTokenKeyName = "transformerToken"
    
    ///Stored API token allows persistance of the data among sessions
    private static var apiToken: String {
        get {
            return UserDefaults.standard.object(forKey: apiTokenKeyName) as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: apiTokenKeyName)
        }
    }
    
    ///Authorization called before each call, ensures that user has token - otherwise new one will be created
    private func authorize(completion: @escaping (Error?) -> Void) {
        guard TransformersAPI.apiToken == "" else {
            completion(nil)
            return
        }
        
        guard let url = URL(string: "\(TransformersAPI.apiURLString)/allspark") else {
            completion(TransformersError(title: "Incorrect url"))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                completion(error ?? TransformersError(title: "Did not receive any data"))
                return
            }
            
            TransformersAPI.apiToken = String(data: data, encoding: .utf8) ?? ""
            
            completion(TransformersAPI.apiToken != "" ? nil : TransformersError(title: "Not able to parse token"))
        }.resume()
    }
    

    ///- parameter randomToken: Used for testing purposes - will generate new API on each init
    init(randomToken: Bool = false) {
        if randomToken {
            TransformersAPI.apiTokenKeyName = UUID().uuidString
        }
    }
    
    ///API call which allows creation of new or edition of the existing `Transformer`
    ///- parameter transformer: if transformer.id is not nil then PUT call will be made with an attempt to edit the existing transformer.
    func createUpdateTransformer(_ transformer: Transformer, completion: @escaping (Transformer?, Error?) -> Void) {
        authorize { (error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let url = URL(string: "\(TransformersAPI.apiURLString)/transformers") else {
                completion(nil, TransformersError(title: "Incorrect url"))
                return
            }
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            var request = URLRequest(url: url)
            
            do {
                let jsonData = try encoder.encode(transformer)
                request.httpBody = jsonData
            } catch {
                completion(nil, error)
                return
            }
            
            request.addValue("Bearer \(TransformersAPI.apiToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = transformer.id != nil ? "PUT" : "POST"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil,  let data = data else {
                    completion(nil, error ?? TransformersError(title: "Did not receive any data"))
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let parsedResponse = try jsonDecoder.decode(Transformer.self, from: data)
                    completion(parsedResponse, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    ///API call which returns current list of `Transformer`
    func getTransformers(completion: @escaping ([Transformer]?, Error?) -> Void) {
        authorize { (error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let url = URL(string: "\(TransformersAPI.apiURLString)/transformers") else {
                completion(nil, TransformersError(title: "Incorrect url"))
                return
            }

            var request = URLRequest(url: url)
            request.addValue("Bearer \(TransformersAPI.apiToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil,  let data = data else {
                    completion(nil, error ?? TransformersError(title: "Did not receive any data"))
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let parsedResponse = try jsonDecoder.decode(TransformersResponse.self, from: data)
                    completion(parsedResponse.transformers, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    ///API call which deletes existing `Transformer`
    ///- parameter id: id of the Transformer to be deleted
    func deleteTransformer(id: String, completion: @escaping (Error?) -> Void) {
        authorize { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let url = URL(string: "\(TransformersAPI.apiURLString)/transformers/\(id)") else {
                completion(TransformersError(title: "Incorrect url"))
                return
            }
            

            var request = URLRequest(url: url)
            request.addValue("Bearer \(TransformersAPI.apiToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                completion(error)
            }.resume()
        }
    }
}
