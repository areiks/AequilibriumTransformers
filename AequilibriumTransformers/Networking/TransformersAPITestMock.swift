//
//  TransformersAPIUITestMock.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import Foundation

/**
 Mock of the TransformersAPI class used for automated tests.
 On init static list of `Transformer` is created and used in the methods from `TransformerDataSource`.
 */
class TransformersAPITestMock: TransformersDataSource {
    private var data: [Transformer] = []
    private var nextID = 0
    
    init() {
        data = [
            Transformer(id: "0", name: "Autobot1", team: .Autobot, rank: 9, parametersValue: 9),
            Transformer(id: "1", name: "Autobot2", team: .Autobot, rank: 8, parametersValue: 8),
            Transformer(id: "2", name: "Autobot3", team: .Autobot, rank: 7, parametersValue: 7),
            Transformer(id: "3", name: "Decepticon1", team: .Decepticon, rank: 8, parametersValue: 8),
            Transformer(id: "4", name: "Decepticon2", team: .Decepticon, rank: 7, parametersValue: 7),
            Transformer(id: "5", name: "Decepticon3", team: .Decepticon, rank: 6, parametersValue: 6)
        ]
    }
    
    func createUpdateTransformer(_ transformer: Transformer, completion: @escaping (Transformer?, Error?) -> Void) {
        var newTransformer = transformer
        if newTransformer.id == nil {
            newTransformer.id = "\(nextID)"
            nextID += 1
            data.append(newTransformer)
        } else {
            data.removeAll(where: { $0.id == transformer.id })
            data.append(newTransformer)
        }
        completion(newTransformer, nil)
    }
    
   func getTransformers(completion: @escaping ([Transformer]?, Error?) -> Void) {
       completion(data, nil)
    }
    
    func deleteTransformer(id: String, completion: @escaping (Error?) -> Void) {
        data.removeAll(where: { $0.id == id })
        completion(nil)
    }
}
