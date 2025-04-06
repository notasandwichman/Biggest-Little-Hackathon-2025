//
//  StoreView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI

struct StoreView: View {
    @StateObject private var viewModel = StoreViewModel()
    @StateObject private var itemModel = ItemViewModel()
    
    let storeID: Int
    
    var body: some View {
        NavigationView{
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Store...")
                } else if let store = viewModel.store {
                    VStack {
                        
                        HStack {
                            Image("\(store.id)")
                                .resizable()
                                .scaledToFit()
                                .frame(width:50)
                            
                            VStack (alignment:.leading){
                                Text("\(store.name)").font(.largeTitle)
                                let totCal = itemModel.items.reduce(0) { $0 + $1.calories }
                                let totCost = itemModel.items.reduce(0.0) { $0 + $1.cost }
                                let mealOptionals = itemModel.items.filter { $0.meal == 1 }
                                let mealAbsolutes = itemModel.items.filter { $0.meal == 0 }.reduce(0) { $0 + $1.calories }
                                let mealTot = mealOptionals.count > 0 ? (mealOptionals.reduce(0) { $0 + $1.calories }/mealOptionals.count) + mealAbsolutes : 0 + mealAbsolutes
                                
                                
                                let avgCalPerCost = totCost > 0 ? Float(totCal)/Float(totCost) : 0
                                
                                Text("Avg. Cal/$: \(String(format: "%.2f", avgCalPerCost)) Calories")
                                    .font(.title3)
                                Text("Avg. Meal Trade: \(mealTot) Calories")
                                    .font(.title3)
                            }
                        }
                        .padding(.top)
                        NavigationLink(destination:StoreMapView(storeID: store.id)){
                            Text("Find on Map")
                                .foregroundColor(.blue)
                        }
                        .navigationTitle("Back to Store")
                        .navigationBarHidden(true)
                        if itemModel.isLoading {
                            ProgressView("Loading Items...")
                        } else if !itemModel.items.isEmpty {
                            
                            List(itemModel.items, id:\.id) {
                                item in
                                VStack (alignment: .leading) {
                                    HStack (alignment: .center){
                                        Text("\(item.name) ").font(.title2).bold(true)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", item.cost))").font(.title2)
                                    }
                                    HStack {
                                        let ratio = String(format: "%.2f", Float(item.calories)/item.cost)
                                        Text("Calories: \(item.calories) - Cal/$: \(ratio) Calories")
                                            .font(.title3)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    .onAppear {
                        itemModel.fetchItems(by: storeID)
                    }
                    
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        
        .onAppear {
            viewModel.fetchStore(by: storeID)
        }
    }
        
}

#Preview {
    StoreView(storeID: 1)
}
