import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Activity Overview")
                    .font(.title)
                    .padding()
                
                // Today's Activities
                VStack(alignment: .leading) {
                    Text("Today's Activities")
                        .font(.headline)
                    ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                        if item.key.contains("today") {
                            ActivityCard(activity: item.value)
                        }
                    }
                }
                .padding()

                // This Week's Activities
                VStack(alignment: .leading) {
                    Text("This Week's Activities")
                        .font(.headline)
                    ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                        if item.key.contains("week") {
                            ActivityCard(activity: item.value)
                        }
                    }
                }
                .padding()

                // This Month's Activities
                VStack(alignment: .leading) {
                    Text("This Month's Activities")
                        .font(.headline)
                    ForEach(manager.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                        if item.key.contains("month") {
                            ActivityCard(activity: item.value)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("Fitness Tracker", displayMode: .inline)
    }
}
