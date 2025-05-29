//
//  HomeView.swift
//
//  Created by Yang on on 18/2/2025.
//

import SwiftUI


struct HomeView: View {
    @State var path = NavigationPath()
    @EnvironmentObject var vm : HomeViewModel
    
    @State var showAlert = false
    
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @State var showDetails = false
    @State var progress: Double = 0.6
    var body: some View {
        dateFor.dateFormat = "yyyy-MM-dd"
        return NavigationStack(path: $path) {
            
            ScrollView(content: {
                if isFirstLaunch {
                    firstView
                    
                } else {
                    topView
                    bottomView
                }
                
            })
                .navigationTitle(Text(dateFor.string(from: vm.nearDay)))
                .navigationBarTitleDisplayMode(.inline)
            
            .modifier(NavBarQuestionViewModifier(showAlert: $showAlert))
           
            .overlay {
                if showAlert {
                    guideView
                        
                }
            }
            .navigationDestination(isPresented: $showDetails) {
                DailyActivityView(nearDayList: vm.nearDayList)
            }
            .onAppear {
                progress = Double(vm.nearDayMinutes)/20.0
            }
        }
    }
    
    var guideView: some View {
        return VStack {
            VStack {
                Spacer().frame(height: 100)
                VStack(alignment: .center) {
                    Text("This is suggestion for your daily activity and how far you achieved it. Click on the button will should you details of today’s step count data.")
                        .font(Font.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    Button {
                        //showDetails = true
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
                }.background(Image("icon_002")
                    .resizable()
                    .padding()
                    .frame(height: 350))
                
                
                Spacer()
            }.background(Color.init(hex: "000000", opacity: 0.4))
                .animation(.easeInOut, value: showAlert)
                .onTapGesture {
                    showAlert.toggle()
                }
        }
    }
    
    
    var firstView: some  View {
        return ZStack(alignment: Alignment.bottom) {
            VStack {
                ZStack {
                    Image("icon_001")
                        .resizable()
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Hello, and welcome to HealthEase! ")
                            .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 20)).lineLimit(2)
                        Text("If you ever feel lost, simply tap the")
                        + Text(" paw icon in the top-right corner ")
                            .foregroundStyle(Color(hex: "FF045F"))
                        + Text("for guidance.")
                        
                        Spacer().frame(height: 20)
                        Text("All blue buttons \n are clickable!")
                        Spacer()
                    }
                    .font(Font.system(size: 22, weight: .bold))
                        .padding(30)
                }
                Spacer().frame(height: 300)
            }
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isFirstLaunch = false
                    } label: {
                        Text("I got it")
                            .font(Font.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.black)
                    }
                    .padding(10)
                    .background(Color(hex: "AFE8FF"))
                    .frame(height: 50)
                    .cornerRadius(25)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 80))
                }
                Image("icon_dog")
                    .resizable()
                    .frame(width: 250, height: 400)
                    .padding()
            }
            .padding()
           
        }
    }
    
    
   var topView: some View {
        
       return VStack(alignment: .leading) {
           VStack(alignment: .leading) {
               Text("You walked")
                  .font(Font.system(size: 24, weight: .bold))
                  .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 0))
              HStack()  {
                  Spacer()
                  Text("\(vm.nearDaySteps) steps")
                      .font(Font.system(size: 25, weight: .bold))
                      .foregroundStyle(Color(hex: "ED883E"))
                  Spacer()
              }.font(Font.system(size: 30, weight: .bold))
                   .padding()
               
               HStack {
                   Spacer()
                   Text(dateFor.string(from: vm.nearDay))
                      .font(Font.system(size: 24, weight: .bold))
                      .padding(EdgeInsets(top: 10, leading: 5, bottom: 20, trailing: 10))
               }
           }
           .font(Font.system(size: 24, weight: .bold))
           .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
           .background(Color(hex: "FFF5E3"))
           .cornerRadius(10)
           .padding(5)
           
           Spacer().frame(height: 30)
           HStack(alignment: .center) {
               Text("Based on your last 10 days, we suggest")
                   .foregroundStyle(Color.black)
                  
               + Text(" 2000 ")
                   .foregroundStyle(Color(hex: "BA30C2"))
               +  Text("steps as your daily target.")
                   .foregroundStyle(Color.black)
           }
           .font(Font.system(size: 24, weight: .bold))
           .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
           .background(Color(hex: "AFE8FF"))
           .cornerRadius(10)
           .padding(5)
       }
        
    }
    
    var bottomView: some View {
        return VStack(alignment: .leading) {
            Button {
                showDetails.toggle()
            } label: {
                Text("Daily Activity")
                    .font(Font.system(size: 28, weight: .bold))
                    .foregroundColor(.black) // 明确指定黑色文字
            }
            .padding()
            .background(Color(hex: "AFE8FF"))
            .frame(height: 50)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.7), radius: 4, x: 0, y: 3)
            .padding(0)
            Text("20 minutes moderate activity")
                .font(Font.system(size: 25, weight: .medium))
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                }
                Text("Daily Activity")
                    .font(Font.system(size: 28, weight: .bold))
                ProgressView(value: progress, total: 1)
                    .tint((Color(hex: "FF2D55")))
                    .background((Color(hex: "007AFF")))
                //
                
                Text("\(vm.nearDayMinutes)/20 mins")
                    .font(Font.system(size: 28, weight: .bold))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
            .padding(5)
            
        }.padding()
            .background(Color(hex: "FFE4B3"))
            .cornerRadius(10)
            .padding(5)
    }
    
    
    
    
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
