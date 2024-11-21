import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        VStack{
            LazyVGrid(columns: Array(repeating: GridItem(spacing:20),count: 2)){
                ForEach(manager.activites.sorted(by:{ $0.value.id < $1.value.id}), id: \.key )
                {item in ActivityCard(activity: item.value)
                }
            }
            .padding(.horizontal)
            }
        .onAppear{
            manager.fetchTodaySteps()
            manager.fetchTodayCalories()
        }
        }
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
