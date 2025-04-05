//
//  iNeedFoodApp.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/4/25.
//

import SwiftUI

@main
struct iNeedFoodApp: App {

    init(){
        _ = DatabaseManager.shared
    }
    
    
    var body: some Scene {
        WindowGroup {
            DefaultView()
        }
    }
}
