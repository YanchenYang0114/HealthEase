//
//  TrendsItemView.swift
//
//  Created by Yang on on 8/3/2025.
//

import SwiftUI

@ViewBuilder
func bulletRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    HStack(alignment: .top, spacing: 8) {
        Text("•").font(.system(size: 24))
        content()
    }
}

struct TrendsItemView: View {
    
    @ObservedObject var trendsVM : TrendsViewModel
    var title = "Week"
    
    var avgDailyStep = 0
    var avgWearingTime = 0.0
    var maxStepDate = "15th Nov"
    var maxStep = 0
    var goalTimes = 0
    //var title = ""
    var trendsDateType : TrendsDateType
    init(trendsVM: TrendsViewModel, trendsDateType: TrendsDateType) {
        self.trendsDateType = trendsDateType
        switch trendsDateType {
        case .week:
            self.title = "Week"
            self.avgDailyStep = trendsVM.weekAvgDailyStep
            self.avgWearingTime = trendsVM.weekAvgWearingTime
            self.maxStep = trendsVM.weekMaxStep
            self.maxStepDate = TrendsItemView.getMonthString(date: trendsVM.weekMaxStepDate)
            
            self.goalTimes = trendsVM.weekGoalTimes
        case .month:
            self.title = "1 Month"
            self.avgDailyStep = trendsVM.monthAvgDailyStep
            self.avgWearingTime = trendsVM.monthAvgWearingTime
            self.maxStep = trendsVM.monthMaxStep
            self.maxStepDate = TrendsItemView.getMonthString(date: trendsVM.monthMaxStepDate)
            self.goalTimes = trendsVM.monthGoalTimes
        case .sixMonth:
            self.title = "6 Months"
            self.avgDailyStep = trendsVM.sixMonthAvgDailyStep
            self.avgWearingTime = trendsVM.sixMonthAvgWearingTime
            
            self.maxStep = trendsVM.sixMonthMaxStep
            self.maxStepDate = TrendsItemView.getMonthString(date: trendsVM.sixMonthMaxStepDate)
            self.goalTimes = trendsVM.sixMonthGoalTimes
        
        }
        _trendsVM = ObservedObject(initialValue: trendsVM)
    }
   /*
    @Published var weekAvgDailyStep = 0 //每天平均步数
    @Published var weekAvgWearingTime = 0.0 //一天平均有几个小时有数据
    @Published var weekMaxStep = 0 // 最大一天步数
    @Published var weekMaxStepDate = Date()//最大一天日期
    @Published var weekGoalTimes = 0//一周完成几次
    */
    var body: some View {
        VStack(alignment: .leading) {
             Text(title)
                .font(Font.system(size: 35, weight: .bold))
                .frame(height: 36)
                .padding(EdgeInsets(top: 3, leading: 20, bottom: 5, trailing: 20))
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(hex: "AFE8FF"))
                        .shadow(color: Color.black.opacity(0.7), radius: 4, x: 0, y: 3) // shadow under background
                )
            bulletRow {
                Text("Avg daily step: ")
                + Text("\(avgDailyStep)").foregroundColor(Color(hex: "FF045F"))
                    .fontWeight(.bold).italic()
            }

            bulletRow {
                Text("Avg Wearing time: ")
                + Text(String(format: "%.lf", 3 * avgWearingTime)).foregroundColor(Color(hex: "FF045F"))
                    .fontWeight(.bold).italic()
                + Text(" hr/day")
            }

            bulletRow {
                Text("Peak: ")
                + Text("20th of February").foregroundColor(Color(hex: "FF045F"))
                    .fontWeight(.bold).italic()
                + Text(" - ")
                + Text("\(maxStep)").foregroundColor(Color(hex: "FF045F"))
                    .fontWeight(.bold).italic()
                + Text(" steps")
            }

            bulletRow {
                Text("Activity goal: ")
                + Text("\(goalTimes)").foregroundColor(Color(hex: "FF045F"))
                    .fontWeight(.bold).italic()
                + Text(" times")
            }
        }
        .font(.system(size: 24))
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow.opacity(0.15)) // light yellow background
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .padding()
    }
    
    static func getMonthString(date:Date) -> String {
        // 将日期转换为字符串
        let dateString = trendsDateFormatter.string(from: date)
        // 获取日期的天数
        let day = Calendar.current.component(.day, from: date)

        // 根据天数添加后缀
        var suffix = "th"
        if day == 1 || day == 21 || day == 31 {
            suffix = "st"
        } else if day == 2 || day == 22 {
            suffix = "nd"
        } else if day == 3 || day == 23 {
            suffix = "rd"
        }

        // 拼接最终的日期字符串
        let finalDateString = "\(day)\(suffix) of \(dateString.components(separatedBy: " ")[1])"
        return finalDateString
    }
}


#Preview {
    TrendsItemView(trendsVM: TrendsViewModel.shared,trendsDateType: .week)
}
