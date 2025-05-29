//
//  BadgesView.swift
//
//  Created by Yang on on 18/2/2025.
//

import SwiftUI


struct BadgesView: View {
    @StateObject var badgesVM = BadgesViewModel.shared
    @State var showAlert = false
    @AppStorage("isBadgesFirstLaunch") var isBadgesFirstLaunch = false
    @State var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(content: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Wearing Time")
                        .font(Font.system(size: 25, weight: .bold))
                    HStack {
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isPerfectMonth ? "icon_perfect_sel" : "icon_perfect", title: "Perfect Month")
                            .onTapGesture {
                                path.append(BadgesType.perfect)
                            }
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDailyCompanion ? "icon_daily_sel" : "icon_daily" , title: "Daily Companion")
                            .onTapGesture {
                                path.append(BadgesType.daily)
                            }
                        Spacer()
                    }
                    
                    Text("Meeting Your Goal")
                        .font(Font.system(size: 25, weight: .bold))
                    HStack {
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDay3 ? "icon_3day_sel" : "icon_3day", title: "3 days")
                            .onTapGesture {
                                path.append(BadgesType.days3)
                            }
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDay7 ? "icon_7day_sel" : "icon_7day", title: "7 days")
                            .onTapGesture {
                                path.append(BadgesType.days7)
                            }
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDay15 ? "icon_15day_sel" : "icon_15day", title: "15 days")
                            .onTapGesture {
                                path.append(BadgesType.days15)
                            }
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDay30 ? "icon_30day_sel" : "icon_30day", title: "30 days")
                            .onTapGesture {
                                path.append(BadgesType.days30)
                            }
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDay90 ? "icon_90day_sel" : "icon_90day", title: "90 days")
                            .onTapGesture {
                                path.append(BadgesType.days90)
                            }
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isDay180 ? "icon_180day_sel" : "icon_180day", title: "180 days")
                            .onTapGesture {
                                path.append(BadgesType.days180)
                            }
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Spacer()
                        BadgesItemView(imageName: badgesVM.isYear ? "icon_1year_sel" : "icon_1year", title: "1 year")
                            .onTapGesture {
                                path.append(BadgesType.year)
                            }
                        Spacer().frame(width: 30)
                        BadgesItemView(imageName: "", title: "")
                        Spacer().frame(width: 30)
                        BadgesItemView(imageName: "", title: "")
                        Spacer()
                    }
                    .padding()
                    
                }.padding()
                
                
            })
            .navigationTitle(Text("Badge"))
            .navigationBarTitleDisplayMode(.inline)
            
            .modifier(NavBarQuestionViewModifier(showAlert: $showAlert))
            
            .overlay {
                if isBadgesFirstLaunch {
                    firstView
                } else {
                    if showAlert {
                        guideView
                        
                    }
                }
            }
            .navigationDestination(for: BadgesType.self) { badgesType in
                
                BadgesDetailsView(badgesType: badgesType)
            }
        }
        
    }
    
    var firstView: some  View {
        return VStack {
            Spacer()
            ZStack {
                Image("icon_004")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                VStack(alignment: .leading) {
                    Text("This page is ")
                    + Text("scrollable")
                        .foregroundStyle(Color(hex: "FF045F"))
                    + Text("—swipe down to find more badges.")
                    Spacer().frame(height: 10)
                    
                    Text("Each badge represents a specific goal. Once you achieve it, the badge will turn coloured. ")
                    + Text("Tap")
                        .foregroundStyle(Color(hex: "FF045F"))
                    + Text(" on any badge to learn how to achieve it.")
                    
                    Spacer().frame(height: 10)
                    
                    Text("Tip: Earning certain badges will unlock special app icons! For more details, check the ")
                    + Text("Settings.")
                        .foregroundStyle(Color(hex: "FF045F"))
                    
                    HStack {
                        Spacer()
                        Button {
                            isBadgesFirstLaunch = false
                        } label: {
                            Text("I got it")
                                .font(Font.system(size: 22, weight: .bold))
                                .foregroundStyle(Color.black)
                        }
                        .padding(10)
                        .background(Color(hex: "AFE8FF"))
                        .frame(height: 44)
                        .cornerRadius(22)
                        .padding()
                        Spacer()
                    }
                }
                .font(Font.system(size: 21, weight: .bold))
                .padding(EdgeInsets(top: 30, leading: 35, bottom: 10, trailing: 35))
            }
            Spacer().frame(height: 10)
        }
        
    }
    
    
    var guideView: some View {
        return VStack {
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Each badge displays its goal and tracks your progress towards achieving it.")
                    .font(Font.system(size: 25, weight: .bold))
                    .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
                
                HStack {
                    Spacer()
                    Button {
                        showAlert = false
                    } label: {
                        Text("I got it")
                            .font(Font.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                    .padding(10)
                    .background(Color(hex: "AFE8FF"))
                    .frame(height: 44)
                    .cornerRadius(22)
                    .padding()
                    Spacer()
                }
                
            }
            .font(Font.system(size: 22, weight: .bold))
            .padding(30)
            .background(Image("icon_003")
                .resizable()
                .padding())
            
            
            Spacer().frame(height: 10)
        }.background(Color.init(hex: "000000", opacity: 0.4))
            .animation(.easeInOut, value: showAlert)
            .onTapGesture {
                showAlert.toggle()
            }
        
    }
    
    
    
}

#Preview {
    NavigationStack {
        BadgesView()
    }
}
