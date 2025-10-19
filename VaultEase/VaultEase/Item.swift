//
//  Item.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
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
