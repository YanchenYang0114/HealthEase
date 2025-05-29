//
//  TabBarView.swift
//
//  Created by Yang on on 18/2/2025.
//

import SwiftUI

struct TabBarView: View {
    @State var selTabIndex = 0
    @StateObject var homeVM = HomeViewModel.shared
    

    var body: some View {
        TabView (selection: $selTabIndex){
            HomeView()
                .environmentObject(homeVM)
                .tabItem {
                    Image(systemName:"house.fill")
                    Text("Today")
                }.tag(0)
            
            TrendsView()
                .tabItem {
                    Image(systemName:"chart.line.uptrend.xyaxis")
                    Text("Trends")
                }
                .tag(1)
            BadgesView()
                .environmentObject(homeVM)
                .tabItem {
                    Image(systemName:"rosette")
                    Text("Badges")
                }
                .tag(2)

        }
    }
}

#Preview {
    TabBarView()
        .environmentObject(TrendsViewModel.shared)
        .environmentObject(BadgesViewModel.shared)
}
