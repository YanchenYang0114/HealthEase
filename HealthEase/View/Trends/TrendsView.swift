//
//  TrendsView.swift
//
//  Created by Yang on on 18/2/2025.
//

import SwiftUI

var trendsDateFormatter: DateFormatter = {
    let dateFor = DateFormatter()
    dateFor.dateFormat = "d MMMM"
    dateFor.locale = Locale.current
    return dateFor
}()

struct TrendsView: View {
    @State var path = NavigationPath()
    @EnvironmentObject var trendsVM : TrendsViewModel
    @State var showAlert = false
    
    
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ScrollView() {
                TrendsItemView(trendsVM: trendsVM,trendsDateType: .week)
                    .onTapGesture {
                        path.append(TrendsDateType.week)
                    }
                TrendsItemView(trendsVM: trendsVM,trendsDateType: .month)
                    .onTapGesture {
                        path.append(TrendsDateType.month)
                    }
                TrendsItemView(trendsVM: trendsVM,trendsDateType: .sixMonth)
                    .onTapGesture {
                        path.append(TrendsDateType.sixMonth)
                    }
            }
            .font(Font.system(size: 25, weight: .medium))
            .modifier(NavBarQuestionViewModifier2(showAlert: $showAlert))
            .navigationTitle(Text("Trends"))
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if showAlert {
                    guideView
                }
            }
            .navigationDestination(for: TrendsDateType.self) { type in
                switch type {
                case .week:
                    WeekView()
                case .month:
                   MonthView()
            
                case .sixMonth:
                    SixMonthView()
                  
                }
                
            }
        }
        
    }
    
    
    var guideView: some View {
        return  VStack {
            Spacer()
            VStack(alignment: .center) {
                VStack {
                    Text("Each paragraph provides a ")
                    
                    + Text("summary ")
                        .foregroundStyle(Color(hex: "FF045F"))
                    + Text("of the corresponding time period. All time label buttons are clickable, allowing you to view more detailed trends.")
                }
                .font(Font.system(size: 22, weight: .bold))
                .foregroundStyle(Color.black)
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
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
                HStack {
                    Spacer()
                }
            }.background(Image("icon_002")
                .resizable()
                .padding()
                .frame(height: 350))
            
            
            Spacer().frame(height: 80)
        }.background(Color.init(hex: "000000", opacity: 0.4))
            .animation(.easeInOut, value: showAlert)
            .onTapGesture {
                showAlert.toggle()
            }
        
    }
   
}


#Preview {
    TrendsView()
        .environmentObject(TrendsViewModel.shared)
}
