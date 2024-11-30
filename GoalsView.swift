import SwiftUI
import UserNotifications

struct GoalsView: View {
    @State private var stepsGoal = ""
    @State private var caloriesGoal = ""
    @State private var monthlyStepsGoal = ""
    @State private var monthlyCaloriesGoal = ""
    @State private var savedStepsGoal: Float = 0.0
    @State private var savedCaloriesGoal: Float = 0.0
    @State private var savedMonthlyStepsGoal: Float = 0.0
    @State private var savedMonthlyCaloriesGoal: Float = 0.0
    @State private var showConfirmation = false
    @State private var goalSavedAnimation = false
    @State private var stepsProgress: Float = 0.0
    @State private var caloriesProgress: Float = 0.0
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Set Your Fitness Goals")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                
                VStack(spacing: 20) {
                    // Goals Input
                    GoalTextField(placeholder: "Enter your step goal", text: $stepsGoal)
                    GoalTextField(placeholder: "Enter your calorie goal", text: $caloriesGoal)
                    
                    // Monthly Goals Input
                    GoalTextField(placeholder: "Enter your monthly step goal", text: $monthlyStepsGoal)
                    GoalTextField(placeholder: "Enter your monthly calorie goal", text: $monthlyCaloriesGoal)
                    
                    // Save Button
                    Button(action: {
                        saveGoals()
                        setReminderNotification()
                        
                        withAnimation {
                            goalSavedAnimation = true
                        }
                    }) {
                        Text("Save Goals")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.horizontal, 40)
                    }
                    
                    // Confirmation message with animation
                    if showConfirmation || goalSavedAnimation {
                        Text("Goals saved!")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding(.top, 10)
                            .transition(.scale)
                    }
                    
                    // Today's Goals Display
                    if savedStepsGoal > 0 {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Goal of today:")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Steps: \(savedStepsGoal, specifier: "%.0f")")
                            Text("Calories: \(savedCaloriesGoal, specifier: "%.0f")")
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                    }
                    
                    // Monthly Goals Display
                    if savedMonthlyStepsGoal > 0 {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Monthly Goal:")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Steps: \(savedMonthlyStepsGoal, specifier: "%.0f")")
                            Text("Calories: \(savedMonthlyCaloriesGoal, specifier: "%.0f")")
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                    }
                    
                    // Progress Section
                    VStack {
                        Text("Progress:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                        
                        // Steps Progress
                        ProgressView("Steps Progress", value: stepsProgress, total: savedStepsGoal)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                        
                        // Calories Progress
                        ProgressView("Calories Progress", value: caloriesProgress, total: savedCaloriesGoal)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                    }
                    .padding(.top, 30)
                    
                    // Spacer
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            loadGoals() // Load saved goals when the view appears
            loadProgress() // Load progress when the view appears
        }
    }
    
    func saveGoals() {
        // Save today's goals to UserDefaults
        if let steps = Float(stepsGoal) {
            savedStepsGoal = steps
            UserDefaults.standard.set(stepsGoal, forKey: "stepsGoal")
        }
        
        if let calories = Float(caloriesGoal) {
            savedCaloriesGoal = calories
            UserDefaults.standard.set(caloriesGoal, forKey: "caloriesGoal")
        }
        
        // Save monthly goals to UserDefaults
        if let monthlySteps = Float(monthlyStepsGoal) {
            savedMonthlyStepsGoal = monthlySteps
            UserDefaults.standard.set(monthlyStepsGoal, forKey: "monthlyStepsGoal")
        }
        
        if let monthlyCalories = Float(monthlyCaloriesGoal) {
            savedMonthlyCaloriesGoal = monthlyCalories
            UserDefaults.standard.set(monthlyCaloriesGoal, forKey: "monthlyCaloriesGoal")
        }
        
        // Show confirmation
        showConfirmation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showConfirmation = false
        }
        
        // Clear text fields
        stepsGoal = ""
        caloriesGoal = ""
        monthlyStepsGoal = ""
        monthlyCaloriesGoal = ""
    }
    
    func loadGoals() {
        // Load today's goals from UserDefaults
        if let savedSteps = UserDefaults.standard.string(forKey: "stepsGoal"),
           let savedCalories = UserDefaults.standard.string(forKey: "caloriesGoal"),
           let savedMonthlySteps = UserDefaults.standard.string(forKey: "monthlyStepsGoal"),
           let savedMonthlyCalories = UserDefaults.standard.string(forKey: "monthlyCaloriesGoal") {
            savedStepsGoal = Float(savedSteps) ?? 0.0
            savedCaloriesGoal = Float(savedCalories) ?? 0.0
            savedMonthlyStepsGoal = Float(savedMonthlySteps) ?? 0.0
            savedMonthlyCaloriesGoal = Float(savedMonthlyCalories) ?? 0.0
        }
    }
    
    func loadProgress() {
        // For demo purposes, assume some random progress
        stepsProgress = Float.random(in: 0...savedStepsGoal)
        caloriesProgress = Float.random(in: 0...savedCaloriesGoal)
    }
    
    func setReminderNotification() {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don't forget your goals! Steps: \(savedStepsGoal), Calories: \(savedCaloriesGoal)"
        content.sound = .default
        
        // Set the trigger (e.g., 5 seconds for testing)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Create the notification request
        let request = UNNotificationRequest(identifier: "goalsReminder", content: content, trigger: trigger)
        
        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification set.")
            }
        }
    }
}

struct GoalTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
    }
}
