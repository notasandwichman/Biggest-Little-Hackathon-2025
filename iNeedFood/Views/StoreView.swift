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
    
    @StateObject private var itemModel = ItemViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Store...")
            } else if let store = viewModel.store {
                VStack {
                    Text("\(store.name)").font(.largeTitle)
                    
                    let totCal = itemModel.items.reduce(0) { $0 + $1.calories }
                    let totCost = itemModel.items.reduce(0.0) { $0 + $1.cost }
                    
                    let avgCalPerCost = totCost > 0 ? Float(totCal)/Float(totCost) : 0
                    
                    Text("Avg. Cal/$: \(String(format: "%.2f", avgCalPerCost)) cal")
                        .font(.title3)
                        .padding(.top, 5)
                    
                    if itemModel.isLoading {
                        ProgressView("Loading Items...")
                    } else if !itemModel.items.isEmpty {
                        List(itemModel.items, id:\.id) {
                            item in
                            VStack (alignment: .leading) {
                                Text(item.name).font(.title3)
                                HStack {
                                    Text("Calories: \(item.calories) |")
                                    Text("$\(item.cost.formatted())")
                                }
                                let ratio = String(format: "%.2f", Float(item.calories)/item.cost)
                                Text("Calories/Dollar: \(ratio) cal")
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                    Spacer()
                }
                .onAppear {
                    itemModel.fetchItems(by: storeID)
                }
                
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchStore(by: storeID)
        }
    }
        
}

#Preview {
    StoreView(storeID: 1)
}
