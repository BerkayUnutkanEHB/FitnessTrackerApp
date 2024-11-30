import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }

    static var startOfWeek: Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Monday
        return calendar.date(from: components)!
    }

    static var startOfMonth: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var activites: [String: Activity] = [:]
    
    @Published var mockActivities: [String: Activity] = [
        "todaySteps": Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: "12,210"),
        "todayCalories": Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount: "1,245")
    ]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories, workout]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekWorkoutStats()
                fetchCurrentMonthStats()
            } catch {
                print("Error fetching health data")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching today step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString())
            DispatchQueue.main.async {
                self.activites["todaySteps"] = activity
            }
        }
        healthStore.execute(query)
    }

    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching today calories data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal 900", image: "flame", tintColor: .red, amount: caloriesBurned.formattedString())
            DispatchQueue.main.async {
                self.activites["todayCalories"] = activity
            }
        }
        healthStore.execute(query)
    }

    func fetchCurrentWeekWorkoutStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching week running data")
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration) / 60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration) / 60
                    strengthCount += duration
                }
            }
            
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "This week", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .cyan, amount: "\(strengthCount) minutes")
            
            DispatchQueue.main.async {
                self.activites["weekRunning"] = runningActivity
                self.activites["weekStrength"] = strengthActivity
            }
        }
        healthStore.execute(query)
    }
    
    func fetchCurrentMonthStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfMonth, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Error fetching month activity data")
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration) / 60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration) / 60
                    strengthCount += duration
                }
            }
            
            let runningActivity = Activity(id: 4, title: "Running", subtitle: "This month", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 5, title: "Strength Training", subtitle: "This month", image: "dumbbell", tintColor: .cyan, amount: "\(strengthCount) minutes")
            
            DispatchQueue.main.async {
                self.activites["monthRunning"] = runningActivity
                self.activites["monthStrength"] = strengthActivity
            }
        }
        healthStore.execute(query)
    }
}
