import SwiftUI
import UserNotifications

struct GoalsView: View {
    @State private var stepsGoal = ""
    @State private var caloriesGoal = ""
    @State private var savedStepsGoal = ""
    @State private var savedCaloriesGoal = ""
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            Text("Set Your Goals")
                .font(.largeTitle)
                .bold()
                .padding()
            
            VStack(spacing: 20) {
                TextField("Enter steps goal", text: $stepsGoal)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                TextField("Enter calories goal", text: $caloriesGoal)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button(action: {
                    // Save goals to UserDefaults
                    saveGoals()
                    
                    // Set notification reminder
                    setReminderNotification()
                }) {
                    Text("Save Goals")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if showConfirmation {
                    Text("Goals saved!")
                        .foregroundColor(.green)
                        .padding()
                }
                
                // Display saved goals of today
                if !savedStepsGoal.isEmpty {
                    VStack {
                        Text("Goal of today:")
                            .font(.headline)
                        Text("Steps: \(savedStepsGoal)")
                        Text("Calories: \(savedCaloriesGoal)")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            loadGoals() // Load saved goals when the view appears
        }
    }
    
    func saveGoals() {
        // Save goals to UserDefaults
        UserDefaults.standard.set(stepsGoal, forKey: "stepsGoal")
        UserDefaults.standard.set(caloriesGoal, forKey: "caloriesGoal")
        
        // Save to local variables for display
        savedStepsGoal = stepsGoal
        savedCaloriesGoal = caloriesGoal
        
        // Show confirmation
        showConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showConfirmation = false
        }
        
        // Clear text fields
        stepsGoal = ""
        caloriesGoal = ""
    }
    
    func loadGoals() {
        // Load goals from UserDefaults
        if let savedSteps = UserDefaults.standard.string(forKey: "stepsGoal"),
           let savedCalories = UserDefaults.standard.string(forKey: "caloriesGoal") {
            savedStepsGoal = savedSteps
            savedCaloriesGoal = savedCalories
        }
    }
    
    func setReminderNotification() {
        // Maak de notificatie-inhoud
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget your goals! Steps: \(savedStepsGoal), Calories: \(savedCaloriesGoal)"
        content.sound = .default
        
        // Stel de trigger in (bijvoorbeeld 5 seconden voor testdoeleinden)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Maak de notificatie-aanvraag
        let request = UNNotificationRequest(identifier: "goalsReminder", content: content, trigger: trigger)
        
        // Voeg de notificatie-aanvraag toe aan de notificatie center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification set.")
            }
        }
    }

}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
    }
}
