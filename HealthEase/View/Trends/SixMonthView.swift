//
//  SixMonthView.swift
//
//  Created by Yang on on 9/3/2025.
//

import SwiftUI
import Charts

struct SixMonthView: View {
    @EnvironmentObject var trendsVM : TrendsViewModel
    
    @State var dataList = [ChartModel]()
    @State var showAlert = false
    @State var maxMonthDate = Date()
    @State var maxMonthStepAverage = 0
    var dateFormatter: DateFormatter = {
        let dateFor = DateFormatter()
        dateFor.dateFormat = "MMM"
        dateFor.locale = Locale.current
        return dateFor
    }()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                }
                //Text("6 Months")
                   // .font(Font.system(size: 28,weight: .bold))
                
                chartView
                TrendsItemView(trendsVM: trendsVM, trendsDateType: .sixMonth)
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
            let sixMonthDict =  Dictionary(grouping: trendsVM.sixMonthList, by: {$0.monthStr})
            let keys =  sixMonthDict.keys.sorted()
            
            var maxMonthDateTemp = Date()
            var maxMonthStepAverageTemp = 0
            
            for (_, key) in keys.enumerated() {
                let value = sixMonthDict[key] ?? []
                let tempDict =  Dictionary(grouping: value, by: {$0.dateStr})
                let stepCount = value.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                let date = value.first?.date ?? Date()
                if tempDict.keys.count > 0 {
                    let average = stepCount/tempDict.keys.count
                    let model1 = ChartModel(xValue: dateFormatter.string(from: date), yValue: Double(average))
                    dataListTemp.append(model1)
                    
                    if average >  maxMonthStepAverageTemp{
                        maxMonthStepAverageTemp = average
                        maxMonthDateTemp = date
                    }
                }
                
            }
            maxMonthDate = maxMonthDateTemp
            maxMonthStepAverage = maxMonthStepAverageTemp
            dataList = dataListTemp
        }
    }
    
    var chartView: some View {
        return GroupBox("Daily Average Step Count") {
            
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
            .frame(width: KScreeW -  50,height: 300)
        }
    }
    
    var guideView: some View {
        return  VStack {
            Spacer()
            VStack(alignment: .center) {
                VStack {
                    Text("Each bar represents the ")
                    + Text("average number of steps per day ")
                        .foregroundStyle(Color(hex: "FF045F"))
                    + Text("during that month. ")
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
        SixMonthView()
            .environmentObject(TrendsViewModel.shared)
    }
}
