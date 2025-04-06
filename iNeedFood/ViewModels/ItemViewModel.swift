//
//  ItemViewModel.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchItems(by storeID:Int) {
        isLoading = true
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if let fetchedItems = DatabaseManager.shared.getItemsByStore(by: storeID) {
                    self.items = fetchedItems
                } else {
                    let store = DatabaseManager.shared.getStoreByID(by: storeID)
                    self.errorMessage = "Failed to fetch items from \(store!.name)."
                }
                self.isLoading = false
            }
        }
    }
}
