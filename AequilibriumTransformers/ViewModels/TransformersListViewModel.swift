//
//  TransformersListViewModel.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import Foundation

/**
 Protocol implemented by networking layer. Provides `Transformer` from the API.
 */
protocol TransformersDataSource: class {
    func createUpdateTransformer(_ transformer: Transformer, completion: @escaping (Transformer?, Error?) -> Void)
    func getTransformers(completion: @escaping ([Transformer]?, Error?) -> Void)
    func deleteTransformer(id: String, completion: @escaping (Error?) -> Void)
}

/**
 Implements `TranformersListViewControllerDataSource` used as viewmodel in `TranformersListViewController`.
 */
class TransformersListViewModel: TranformersListViewControllerDataSource {
    private var dataSource: TransformersDataSource =  ProcessInfo.processInfo.arguments.contains("UI-TESTING") ? TransformersAPITestMock() : TransformersAPI()
    private var data: [Transformer] = []
    
    ///Asynchronous call for the initial data load. Used for the UI to present loading indicator.
    ///- parameter transformer: if transformer.id is not nil then PUT call will be made with an attempt to edit the existing transformer.
    func loadData(completion: @escaping () -> Void) {
        dataSource.getTransformers {[weak self] (transformers, error) in
            self?.data = transformers?.sorted(by: { $0.rank > $1.rank }).sorted(by: { $0.team.rawValue < $1.team.rawValue }) ?? []
            completion()
        }
    }
    
    ///Number of currently loaded items
    func numberOfItems() -> Int {
        return data.count
    }
    
    ///Returns `Transformer` for the given index
    ///- parameter row: index of transformer
    func itemForRow(row: Int) -> Transformer {
        return data[row]
    }
    
    ///Deletes `Transformer` for the given index
    ///- parameter row: index of transformer
    func deleteItem(row: Int, completion: @escaping () -> Void) {
        guard let id = data[row].id else {
            completion()
            return
        }
        
        dataSource.deleteTransformer(id: id) {[weak self] (error) in
            if error == nil {
                self?.data.removeAll(where: { $0.id == id })
            }
            completion()
        }
    }
    
    ///Returns all currently loaded `Transformer`
    func allItems() -> [Transformer] {
        return data
    }
    
    ///Creates new or edits provided transformer.
    ///If transformer.id will be nil then new transformer will be created.
    ///- parameter transformer: transformer to create or edit
    func addEditTransformer(transformer: Transformer, completion: @escaping () -> Void) {
        dataSource.createUpdateTransformer(transformer) {[weak self] (transformer, error) in
            self?.dataSource.getTransformers { (transformers, error) in
                self?.data = transformers?.sorted(by: { $0.rank > $1.rank }).sorted(by: { $0.team.rawValue < $1.team.rawValue })  ?? []
                completion()
            }
        }
    }
}
