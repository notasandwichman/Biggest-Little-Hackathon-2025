//
//  DefaultView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/4/25.
//

import SwiftUI

struct DefaultView: View {
//    @StateObject private var viewModel = StoreViewModel()
    
    
    var body: some View {
        //TODO: Nav Bar (include Map View, List View)
        StoreListView()
    }
}

#Preview {
    DefaultView()
}
