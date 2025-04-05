//
//  Item.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/4/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
