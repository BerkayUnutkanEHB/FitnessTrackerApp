import SwiftUI
import CoreMotion

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    let welcomeArray = ["Welcome", "Bienvenue", "Welkom"]
    @State private var currentIndex = 0
    
    // CoreMotion Activity Manager
    private let motionActivityManager = CMMotionActivityManager()
    @State private var currentActivity: String = "Unknown"
    @State private var backgroundColor: Color = .gray  // For activity-specific color
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .padding()
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 1), value: currentIndex)
                .onAppear{
                    startWelcomeTimer()
                    startActivityDetection() // Start activity detection
                }
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                    ActivityCard(activity: item.value)  // Keep the ActivityCard
                }
            }
            .padding(.horizontal)
            
            // Realtime activity detection display with color change
            Text("Current Activity: \(currentActivity)")
                .font(.title2)
                .padding()
                .foregroundColor(.white)
                .background(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)  // Center the text in the view
                .padding(.top, 50)  // Add some space from the top
                .animation(.easeInOut(duration: 0.5), value: currentActivity)  // Add smooth transition for background color change
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    func startWelcomeTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
    
    // Start activity detection
    func startActivityDetection() {
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { activity in
                guard let activity = activity else { return }
                
                // Update current activity and background color based on detected activity
                withAnimation(.easeInOut(duration: 0.5)) {
                    if activity.walking {
                        currentActivity = "Walking"
                        backgroundColor = .green
                    } else if activity.running {
                        currentActivity = "Running"
                        backgroundColor = .blue
                    } else if activity.cycling {
                        currentActivity = "Cycling"
                        backgroundColor = .orange
                    } else if activity.stationary {
                        currentActivity = "Stationary"
                        backgroundColor = .gray
                    } else {
                        currentActivity = "Unknown"
                        backgroundColor = .gray
                    }
                }
            }
        } else {
            print("Activity detection is not available.")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HealthManager())
    }
}
