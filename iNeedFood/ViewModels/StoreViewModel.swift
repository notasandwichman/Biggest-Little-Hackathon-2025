//
//  StoreViewModel.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI

class StoreViewModel: ObservableObject {
    @Published var store: Store?
    @Published var stores: [Store] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchStore(by id:Int){
        isLoading = true
        
        DispatchQueue.global().async {
            if let fetchedStore = DatabaseManager.shared.getStoreByID(by: id) {
                DispatchQueue.main.async {
                    self.store = fetchedStore
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load store."
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchAllStores(){
        isLoading = true
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if let fetchedStores = DatabaseManager.shared.getAllStores() {
                    print("Fetched stores: \(fetchedStores)")
                    self.stores = fetchedStores
                } else {
                    self.errorMessage = "Failed to fetch stores."
                }
                self.isLoading = false
            }
        }
    }
}
