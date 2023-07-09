//
//  Item.swift
//  JobTrack
//
//  Created by Nathan Kee on 2023-07-08.
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
