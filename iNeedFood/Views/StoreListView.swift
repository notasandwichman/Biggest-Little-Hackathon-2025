//
//  StoreListView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI

struct StoreListView: View {
    @StateObject private var viewModel = StoreViewModel()
    @StateObject private var itemModel = ItemViewModel()
    
    var body: some View {
        //Store List
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if !viewModel.stores.isEmpty {
                List (viewModel.stores, id: \.id) {
                    store in
                    NavigationLink(destination: StoreView(storeID: store.id)){
                        HStack {
                            VStack (alignment: .leading) {
                                Text(store.name)
                                    .font(.title)
                                Text(store.location)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Image("\(store.id)")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                    }
                    .padding(.vertical)
                }
                .listStyle(PlainListStyle())
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear{
            viewModel.fetchAllStores()
        }
        
    }
}
#Preview {
    StoreListView()
}
