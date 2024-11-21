//
//  FitnessTabView.swift
//  FitnessTrackerApp
//
//  Created by Berkay Unutkan on 21/11/2024.
//
import SwiftUI

struct FitnessTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
                .environmentObject(manager)
            ContentView()
                .tag("Content")
                .tabItem {
                    Image(systemName: "person")
        }
    }
}
}

struct FitnessTabView_Previews : PreviewProvider {
    static var previews: some View{
        FitnessTabView()
    }
}
