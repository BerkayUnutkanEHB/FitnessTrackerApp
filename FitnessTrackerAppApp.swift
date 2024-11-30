import SwiftUI
import UserNotifications

@main
struct FitnessTrackerAppApp: App {
    @StateObject var manager = HealthManager()
    
    init() {
        // Vraag toestemming voor meldingen
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            FitnessTabView()
                .environmentObject(manager)
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
