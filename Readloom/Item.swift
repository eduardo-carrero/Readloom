//
//  Item.swift
//  Readloom
//
//  Created by Eduardo Carrero Yubero on 01/08/2026.
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
