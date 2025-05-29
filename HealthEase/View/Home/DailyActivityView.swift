//
//  DailyActivityView.swift
//
//  Created by Yang on on 1/3/2025.
//

import SwiftUI
import Charts

struct DailyActivityView: View {
    @State var showAlert = false
    @EnvironmentObject var vm : HomeViewModel
    var nearDayList = [StepModel]()
    @State var dataList = [StepModel]()
    init(nearDayList: [StepModel]) {
        self.nearDayList = nearDayList;
        guard let dayDate = self.nearDayList.first?.date else { return }
        var days = [Date]()
       let first = Calendar.current.startOfDay(for: dayDate)
       
        
        for i in 0..<144 {
            let item = Calendar.current.date(byAdding: .minute, value: i * 10, to: first)!
            days.append(item)
        }
        var dataListTemp = [StepModel]()
        dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for (_, itme) in days.enumerated() {
           let filters = nearDayList.filter({isTenMinutes(from: itme, to: $0.date)})
            let stepCount = filters.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
            let model = StepModel(timestamp: dateFor.string(from: itme), id: filters.first?.id ?? "", stepCount: String(stepCount), date: itme)
        
            //print("model:\(model.stepCount)")
            dataListTemp.append(model)
            
        }
        _dataList = State(initialValue: dataListTemp)
    }
    
    func isTenMinutes(from:Date,to:Date) -> Bool {
        let compare = Calendar.current.dateComponents([.minute], from: from, to: to)
        return compare.minute! >= 0 && compare.minute! < 10
    }
    
    var body: some View {
        
        ScrollView(content: {
            chartView
            /*
                
             */
            VStack(alignment: .leading) {
                Text("It is recommended that you walk at a pace of ")
                   
                + Text("80 steps per minute")
                    .foregroundStyle(Color(hex: "FF045F"))
                + Text(" to achieve moderate intensity.")
                
                Spacer().frame(height: 20)
                Text("The graph above displays your daily step count per minute, with the ")
                   
                + Text("red region")
                    .foregroundStyle(Color(hex: "FF045F"))
                + Text(" highlighting the time periods where you reached moderate intensity.")
                Spacer()
            }
            .font(Font.system(size: 28, weight: .medium))
                .padding(20)
        })
        .frame(width: KScreeW)
        .modifier(NavBarQuestionViewModifier(showAlert: $showAlert))
        .overlay {
            if showAlert {
                guideView
                
            }
        }
        
        .toolbarVisibility(.hidden, for: .tabBar)
        
    }

    var chartView: some View {
        return GroupBox("Daily Activity") {
            
            Chart {
                ForEach(dataList, id: \.self) {
                    LineMark(
                        x: .value("time", $0.timestamp),
                        y: .value("step", Double($0.stepCount) ?? 0)
                    )
                    
                }
                
            }
            .chartXAxis(.hidden)
            HStack {
                Spacer()
                Text("6AM")
                Spacer()
                Text("12AM")
                Spacer()
                Text("6PM")
                Spacer()
            }.font(Font.system(size: 25, weight: .bold))

            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                        .font(.system(size: 20, weight:.bold)) // Adjust the size here
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    var guideView: some View {
        return VStack {
            VStack {
                Spacer().frame(height: 100)
                VStack(alignment: .center) {
                    Text("This recommended pace varies for each individual as it is calculated based on personal factors such as age, weight, and height.")
                        .font(Font.system(size:23, weight: .bold))
                        .foregroundStyle(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    Button {
                        
                        showAlert = false
                    } label: {
                        Text("I got it")
                            .font(Font.system(size: 23, weight: .bold))
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
            }.background(Color.init(hex: "000000", opacity: 0.1))
                .animation(.easeInOut, value: showAlert)
                .onTapGesture {
                    showAlert.toggle()
                }
        }
    }
    
}

#Preview {
    NavigationStack {
        DailyActivityView(nearDayList: HomeViewModel.shared.nearDayList)
            .environmentObject(HomeViewModel.shared)
    }
    
}
