//
//  JobTrackApp.swift
//  JobTrack
//
//  Created by Nathan Kee on 2023-07-08.
//

import SwiftUI
import SwiftData

@main
struct JobTrackApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
