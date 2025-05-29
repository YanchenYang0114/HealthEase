//
//  MonthView.swift
//
//  Created by Yang on on 9/3/2025.
//

import SwiftUI
import Charts

struct MonthView: View {
    @EnvironmentObject var trendsVM : TrendsViewModel
    
    @State var dataList = [ChartModel]()
    @State var showAlert = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                }
                Text("1 Month")
                    .font(Font.system(size: 28,weight: .bold))
                
                chartView
                TrendsItemView(trendsVM: trendsVM, trendsDateType: .month)
            }.padding()
           
         
             
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .modifier(NavBarQuestionViewModifier(showAlert: $showAlert))
        .overlay {
            if showAlert {
                guideView
            }
        }
        .task {
            
            var dataListTemp = [ChartModel]()
            let monthDict =  Dictionary(grouping: trendsVM.monthList, by: {$0.dateStr})
            let keys =  monthDict.keys.sorted()
            
            var list1 = [StepModel]()
            var list2 = [StepModel]()
            var list3 = [StepModel]()
            var list4 = [StepModel]()
            var day1 = 0
            var day2 = 0
            var day3 = 0
            var day4 = 0
            
            for (_, key) in keys.enumerated() {
                let value = monthDict[key] ?? []
                if key.hasSuffix("-01") || key.hasSuffix("-02") || key.hasSuffix("-03") || key.hasSuffix("-04") || key.hasSuffix("-05") || key.hasSuffix("-06") || key.hasSuffix("-07"){
                    list1.append(contentsOf: value)
                    day1 += 1
                } else if key.hasSuffix("-08") || key.hasSuffix("-09") || key.hasSuffix("-10") || key.hasSuffix("-11") || key.hasSuffix("-12") || key.hasSuffix("-13") || key.hasSuffix("-14")  {
                    list2.append(contentsOf: value)
                    day2 += 1
                } else if key.hasSuffix("-15") || key.hasSuffix("-16") || key.hasSuffix("-17") || key.hasSuffix("-18") || key.hasSuffix("-19") || key.hasSuffix("-20") || key.hasSuffix("-21")  {
                    list3.append(contentsOf: value)
                    day3 += 1
                } else   {
                    list4.append(contentsOf: value)
                    day4 += 1
                }
                
            }
            if day1 > 0 {
                let stepCount1 = list1.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                let model1 = ChartModel(xValue: "1-7th", yValue: Double(stepCount1/day1))
                dataListTemp.append(model1)
            }
            
            if day2 > 0 {
                let stepCount2 = list2.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                let model2 = ChartModel(xValue: "8-14th", yValue: Double(stepCount2/day2))
                dataListTemp.append(model2)
            }
            if day3 > 0 {
                let stepCount3 = list3.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                let model3 = ChartModel(xValue: "15-21th", yValue: Double(stepCount3/day3))
                dataListTemp.append(model3)
            }
            
            
            
            if day4 > 0 {
                let stepCount4 = list4.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                let lastDate = list4.last?.date ?? Date()
                let days = Calendar.current.component(.day, from: lastDate)
                let model4 = ChartModel(xValue: "22-\(days)th", yValue: Double(stepCount4/day4))
                dataListTemp.append(model4)
            }
            
            dataList = dataListTemp
        }
    }
    
    var chartView: some View {
        return GroupBox("Daily Activity") {
            
            Chart {
                ForEach(dataList, id: \.self) { chartModel in
                    
                    BarMark(
                        x: .value("time", chartModel.xValue),
                        y: .value("step", chartModel.yValue)
                    )
                }
                
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                        .font(.system(size: 20, weight:.bold)) // Adjust the size here
                        .foregroundStyle(.black)
                }
            }
            .frame(width: KScreeW - 50,height: 300)
        }
    }
    
    
    var guideView: some View {
        return  VStack {
            Spacer()
            VStack(alignment: .center) {
                VStack {
                    Text("The number above each bar shows the ")
                    + Text("average number of steps per day ")
                        .foregroundStyle(Color(hex: "FF045F"))
                    + Text("during that period, not the total steps. ")
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
    NavigationStack {
        MonthView()
            .environmentObject(TrendsViewModel.shared)
    }
}
