import SwiftUI

struct FitnessTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .environmentObject(manager)
            ContentView()
                .tag("Content")
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Activity")
                }
            GoalsView()
                .tag("Goals")
                .tabItem {
                    Image(systemName: "target")
                    Text("Set Goals")
                }
            MotivationView()
                .tag("Motivation")
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Motivation")
                }
        }
    }
}

struct FitnessTabView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTabView()
    }
}
