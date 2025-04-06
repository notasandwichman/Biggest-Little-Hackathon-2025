//
//  DefaultView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/4/25.
//

import SwiftUI

struct DefaultView: View {
//    @StateObject private var viewModel = StoreViewModel()
    @State private var currentTab = 0
    
    var body: some View {
        VStack {
            //Tab Bar
            HStack {
                Spacer()
                
                Button(action: {currentTab = 0}) {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List View")
                    }
                    .padding()
                    .foregroundColor(currentTab == 0 ? .blue : .gray)
                }
                
                Spacer()
                
                Button(action: {currentTab = 1}) {
                    VStack {
                        Image(systemName: "map.fill")
                        Text("Map View")
                    }
                    .padding()
                    .foregroundColor(currentTab == 1 ? .blue : .gray)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .shadow(radius: 5)
            
            //Content Views
            Spacer()
            
            if currentTab == 1 {
                MapView()
            } else {
                StoreListView()
                Spacer()
            }
        }
    }
}

#Preview {
    DefaultView()
}
