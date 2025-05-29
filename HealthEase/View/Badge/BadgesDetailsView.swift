//
//  BadgesDetailsView.swift
//
//  Created by Yang on on 12/3/2025.
//

import SwiftUI

struct BadgesDetailsView: View {
    @StateObject var badgesVM = BadgesViewModel.shared
    
    @State var badgesType:BadgesType = BadgesType.perfect
    @State var image = "icon_perfect_sel"
    @State var section = "Meeting Your Goal"
    @State var title = ""
    @State var content = ""
    @State var isFinish = false
    @State var toGoDays = 0
    
    @State var showAlert = false
    init(badgesType: BadgesType) {
        _badgesType = State(initialValue: badgesType)
        
        switch badgesType {
            
        case .perfect:
            _section = State(initialValue: "Wearing Time")
            _isFinish = State(initialValue: badgesVM.isPerfectMonth)
            
            if !badgesVM.isPerfectMonth {
                _content = State(initialValue: "\(30-badgesVM.wearTimeDays) days to go")
            }
            
            
        case .daily:
            _section = State(initialValue: "Wearing Time")
            _isFinish = State(initialValue: badgesVM.isDailyCompanion)
           
            if !badgesVM.isDailyCompanion {
                _content = State(initialValue: "\(180-badgesVM.wearTimeDays) days to go")
              
            }
            
        case .days3:
            _isFinish = State(initialValue: badgesVM.isDay3)
            if !badgesVM.isDay3 {
                _content = State(initialValue: "\(3-badgesVM.meetingDays) days to go")
            }
        case .days7:
            _isFinish = State(initialValue: badgesVM.isDay7)
            if !badgesVM.isDay7 {
                _content = State(initialValue: "\(7-badgesVM.meetingDays) days to go")
            }
        case .days15:
            _isFinish = State(initialValue: badgesVM.isDay15)
            if !badgesVM.isDay15 {
                _content = State(initialValue: "\(15-badgesVM.meetingDays) days to go")
            }
        case .days30:
            _isFinish = State(initialValue: badgesVM.isDay30)
            if !badgesVM.isDay30 {
                _content = State(initialValue: "\(30-badgesVM.meetingDays) days to go")
            }
        case .days90:
            _isFinish = State(initialValue: badgesVM.isDay90)
            if !badgesVM.isDay90 {
                _content = State(initialValue: "\(90-badgesVM.meetingDays) days to go")
            }
        case .days180:
            _isFinish = State(initialValue: badgesVM.isDay180)
            if !badgesVM.isDay180 {
                _content = State(initialValue: "\(180-badgesVM.meetingDays) days to go")
            }
        case .year:
            _isFinish = State(initialValue: badgesVM.isYear)
            if !badgesVM.isYear {
                _content = State(initialValue: "\(365-badgesVM.meetingDays) days to go")
            }
        }
        _title = State(initialValue: badgesType.rawValue)
        
        
        if  isFinish {
            _content = State(initialValue: "Congratulations on achieving your goal")
        }
        if isFinish {
            _image = State(initialValue: badgesType.image + "_sel")
        } else {
            _image = State(initialValue: badgesType.image)
        }
        print("init(badgesType: BadgesType)")
        
    }
    var body: some View {
        
        ScrollView {
            VStack {
                Text(section)
                    .font(Font.system(size: 25,weight: .medium))
                Spacer().frame(height: 50)
                ZStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 350)
                    Text(content)
                        .frame(width: 200)
                        .font(Font.system(size: isFinish ? 20 : 25,weight: .bold))
                        .padding(.bottom,70)
                        
                }
                Spacer().frame(height: 100)
                Text(title)
                    .font(Font.system(size: 28,weight: .bold))
                HStack {
                    Spacer()
                }
            }
        }
        
        .modifier(NavBarQuestionViewModifier(showAlert: $showAlert))
        
        .overlay {
            if showAlert {
                guideView
                
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
    }
    
    var guideView: some View {
        
        return VStack {
            
            Spacer()
            
            VStack(alignment: .leading) {
                if isFinish {
                    Text("Once you achieve a badge, it will flip to display how many times you have already earned it and the specific dates of achievement.")
                        .font(Font.system(size: 25, weight: .bold))
                        .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
                } else {
                    
                    Text("Each badge displays its goal and tracks your progress towards achieving it.")
                        .font(Font.system(size: 25, weight: .bold))
                        .padding(EdgeInsets(top: 30, leading: 10, bottom: 0, trailing: 10))
                }
                
                
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
        BadgesDetailsView(badgesType: BadgesType.daily)
    }
}
