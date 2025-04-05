//
//  StoreView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = StoreViewModel()
    
    let storeID: Int
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let store = viewModel.store {
                Text("Store Name: \(store.name)")
                //TODO: Add more store details
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchStore(by: storeID)
        }
    }
        
}
