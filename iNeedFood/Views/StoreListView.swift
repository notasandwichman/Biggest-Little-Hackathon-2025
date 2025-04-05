//
//  StoreListView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI

struct StoreListView: View {
    @StateObject private var viewModel = StoreViewModel()
    
    var body: some View {
        //Store List
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if !viewModel.stores.isEmpty {
                List (viewModel.stores, id: \.id) {
                    store in
                    NavigationLink(destination: StoreView(storeID: store.id)){
                        Text(store.name)
                    }
                    .padding(.vertical, 5)
                }
                .padding()
                .navigationTitle("Stores")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear{
            viewModel.fetchAllStores()
        }
        .padding()
        Spacer()
    }
}
