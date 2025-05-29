//
//  WeekView.swift
//
//  Created by Yang on on 9/3/2025.
//

import SwiftUI
import Charts


struct WeekView: View {
    @EnvironmentObject var trendsVM : TrendsViewModel
    
    @State var dataList = [ChartModel]()
    @State var showAlert = false
    
    var dateFormatter: DateFormatter = {
        let dateFor = DateFormatter()
        dateFor.dateFormat = "MMMM"
        dateFor.locale = Locale.current
        return dateFor
    }()

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                }
                //Text("Week")
                //    .font(Font.system(size: 35,weight: .bold))
                
                chartView
                TrendsItemView(trendsVM: trendsVM, trendsDateType: .week)
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
            let weekDict =  Dictionary(grouping: trendsVM.weekList, by: {$0.dateStr})
            if weekDict.keys.count > 7 {
                return
            }
            let weekNameList = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
            var index = 0
            for (_,values) in weekDict {
                let stepCount = values.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                
                let model = ChartModel(xValue: weekNameList[index], yValue: Double(stepCount))
                dataListTemp.append(model)
                index += 1
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
                AxisMarks(values: .automatic) { value in // 这个auto不对
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
                Text("Each bar represents the number of steps you took on that day. ")
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
        WeekView()
            .environmentObject(TrendsViewModel.shared)
    }
}
