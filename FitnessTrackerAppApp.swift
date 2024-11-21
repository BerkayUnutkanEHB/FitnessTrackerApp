//
//  FitnessTrackerAppApp.swift
//  FitnessTrackerApp
//
//  Created by Berkay Unutkan on 21/11/2024.
//

import SwiftUI

@main
struct FitnessTrackerAppApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
                .environmentObject(manager)
        }
    }
}
