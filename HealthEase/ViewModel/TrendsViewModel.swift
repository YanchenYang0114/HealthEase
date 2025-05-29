//
//  TrendsViewModel.swift
//
//  Created by Yang on on 8/3/2025.
//

import Foundation
import SwiftData

enum TrendsDateType {
    case week
    case month
    case sixMonth
}

class TrendsViewModel: ObservableObject {
    static let shared = TrendsViewModel()
    @Published var lastDate = Date()
    @Published var loadFinish = false
    var  container: ModelContainer!
    
    @Published var weekList = [StepModel]()
    @Published var weekAvgDailyStep = 0 //每天平均步数
    @Published var weekAvgWearingTime = 0.0 //一天平均有几个小时有数据
    @Published var weekMaxStep = 0 // 最大一天步数
    @Published var weekMaxStepDate = Date()//最大一天日期
    @Published var weekGoalTimes = 0//一周完成几次
    @Published var weekStart = Date()
    @Published var weekEnd = Date()
    
    @Published var monthList = [StepModel]()
    @Published var monthAvgDailyStep = 0
    @Published var monthAvgWearingTime = 0.0
    @Published var monthMaxStep = 0
    @Published var monthMaxStepDate = Date()
    @Published var monthGoalTimes = 0
    @Published var monthStart = Date()
    @Published var monthEnd = Date()
    
    @Published var sixMonthList = [StepModel]()
    @Published var sixMonthAvgDailyStep = 0
    @Published var sixMonthAvgWearingTime = 0.0
    @Published var sixMonthMaxStep = 0
    @Published var sixMonthMaxStepDate = Date()
    @Published var sixMonthGoalTimes = 0
    @Published var sixMonthStart = Date()
    @Published var sixMonthEnd = Date()
    
    
    var dateFormatter: DateFormatter = {
        let dateFor = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd"
        dateFor.locale = Locale.current
        return dateFor
    }()
    
    init() {
        //updateData()
    }
    
    func updateData() {
        Task {
            
            guard let lastDay = await HomeViewModel.shared.getLastData() else {
                return
            }
            let lastDate = Calendar.current.date(byAdding: .day, value: -1, to: lastDay.date)!
            DispatchQueue.main.async {
                self.lastDate = lastDate
            }
            
            //1week

            let weekList = await queryDataList(lastDate: lastDate, dateType:.week)
            let weekTotal = weekList.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
            let weekDict =  Dictionary(grouping: weekList, by: {$0.dateStr})
            let weekValues = Array( weekDict.values)
            var weekMaxStepDateTemp = Date()
            var weekMaxStepTemp = 0
            var weekGoalTimesTemp = 0
            for (_,values) in weekValues.enumerated() {
               
                let stepCount = values.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                if stepCount >= weekMaxStepTemp {
                    weekMaxStepDateTemp = values.first?.date ?? Date()
                    weekMaxStepTemp = stepCount
                }
                //每分钟80步数,一天有多少分钟
                let minutes = values.reduce(0, {$0 + (((Int($1.stepCount) ?? 0) >= 80) ? 1: 0)})
                if minutes >= 20 {
                    weekGoalTimesTemp += 1
                }
            }
            
            let weekMaxStepDate = weekMaxStepDateTemp
            let weekMaxStep = weekMaxStepTemp
            let weekGoalTimes = weekGoalTimesTemp
            DispatchQueue.main.async {
                //self.weekList = weekList
                self.weekAvgDailyStep = weekTotal/weekDict.keys.count
                self.weekAvgWearingTime =  Double(weekList.count) / Double(weekDict.keys.count) / 60.0
                self.weekMaxStepDate = weekMaxStepDate
                self.weekMaxStep = weekMaxStep
                self.weekGoalTimes = weekGoalTimes
                self.weekList = weekList
            }
            
            ///2 month
            
            let monthList = await queryDataList(lastDate: lastDate, dateType:.month)
            let monthTotal = monthList.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
            //计算一月内那一天步数最多
            let monthDict =  Dictionary(grouping: monthList, by: {$0.dateStr})
            let monthValues = Array( monthDict.values)
            var monthMaxStepDateTemp = Date()
            var monthMaxStepTemp = 0
            var monthGoalTimesTemp = 0
            for (_,values) in monthValues.enumerated() {
               
                let stepCount = values.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                if stepCount >= monthMaxStepTemp {
                    monthMaxStepDateTemp = values.first?.date ?? Date()
                    monthMaxStepTemp = stepCount
                }
                //每分钟80步数,一天有多少分钟
                let minutes = values.reduce(0, {$0 + (((Int($1.stepCount) ?? 0) >= 80) ? 1: 0)})
                if minutes >= 20 {
                    monthGoalTimesTemp += 1
                }
            }
            let monthMaxStepDate = monthMaxStepDateTemp
            let monthMaxStep = monthMaxStepTemp
            let monthGoalTimes = monthGoalTimesTemp
            DispatchQueue.main.async {
                self.monthAvgDailyStep = monthTotal/monthDict.keys.count
                self.monthAvgWearingTime =  Double(monthList.count) / Double(monthDict.keys.count) / 60.0
                self.monthMaxStepDate = monthMaxStepDate
                self.monthMaxStep = monthMaxStep
                self.monthGoalTimes = monthGoalTimes
                self.monthList = monthList
            }
            
            //3 six month
            let sixMonthList = await queryDataList(lastDate: lastDate, dateType:.sixMonth)
            let sixMonthTotal = sixMonthList.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
            //计算一月内那一天步数最多
            let sixMonthDict =  Dictionary(grouping: sixMonthList, by: {$0.dateStr})
            let sixMonthValues = Array(sixMonthDict.values)
            var sixMonthMaxStepDateTemp = Date()
            var sixMonthMaxStepTemp = 0
            var sixMonthGoalTimesTemp = 0
            for (_,values) in sixMonthValues.enumerated() {
               
                let stepCount = values.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                if stepCount >= sixMonthMaxStepTemp {
                    sixMonthMaxStepDateTemp = values.first?.date ?? Date()
                    sixMonthMaxStepTemp = stepCount
                }
                //每分钟80步数,一天有多少分钟
                let minutes = values.reduce(0, {$0 + (((Int($1.stepCount) ?? 0) >= 80) ? 1: 0)})
                if minutes >= 20 {
                    sixMonthGoalTimesTemp += 1
                }
            }
            
            let sixMonthMaxStepDate = sixMonthMaxStepDateTemp
            let sixMonthMaxStep = sixMonthMaxStepTemp
            let sixMonthGoalTimes = sixMonthGoalTimesTemp
            DispatchQueue.main.async {
                self.sixMonthAvgDailyStep = sixMonthTotal/sixMonthDict.keys.count
                self.sixMonthAvgWearingTime =  Double(sixMonthList.count) / Double(sixMonthDict.keys.count) / 60.0
                self.sixMonthMaxStepDate = sixMonthMaxStepDate
                self.sixMonthMaxStep = sixMonthMaxStep
                self.sixMonthGoalTimes = sixMonthGoalTimes
                self.sixMonthList = sixMonthList
            }
          
            DispatchQueue.main.async {
                self.loadFinish = true
            }
        }
    }
    
    @MainActor func queryDataList(lastDate:Date, dateType: TrendsDateType) -> [StepModel] {
        var start = Date()
        var end = Date()
        let calendar = Calendar.current
        let startOfDay =  calendar.startOfDay(for: lastDate)
        let endOfDay = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
        switch dateType {
        case .week:
            let weekday = calendar.component(.weekday, from: endOfDay)
            end = calendar.date(byAdding: .day, value: (-weekday+1), to: endOfDay)!
            //27 4   5
            start = calendar.date(byAdding: DateComponents(day: -7, second: 1), to: end)!
            self.weekStart = start
            self.weekEnd = end
            print("week__start:\(start)")
            print("week__end:\(end)")
            
        default:
            let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: lastDate) ?? Date()
            // 获取上个月的范围
            let range = calendar.range(of: .day, in: .month, for: lastMonthDate)
            // 获取上个月的最后一天
            var components = calendar.dateComponents([.year, .month], from: lastMonthDate)
            components.day = range?.count ?? 30
            end = calendar.date(from: components) ?? Date()
            end = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: end)!
            //27 4   5
            if dateType == .month {
                start = calendar.date(byAdding: DateComponents(day: -(range?.count ?? 30), second: 1), to: end)!
                self.monthStart = start
                self.monthEnd = end
                print("month__start:\(start)")
                print("month__end:\(end)")
            } else {
                //sixMonth
                let lastSixMonthDate = calendar.date(byAdding: .month, value: -7, to: lastDate) ?? Date()
                start = calendar.date(bySetting: .day, value: 1, of: lastSixMonthDate) ?? Date()
                self.sixMonthStart = start
                self.sixMonthEnd = end
                print("6month__start:\(start)")
                print("6month__end:\(end)")
            }
            break
        }
        
        let predicate =  #Predicate<StepModel> {
            $0.date >= start && $0.date < end
        }
        let descriptor = FetchDescriptor<StepModel>(predicate: predicate, sortBy: [SortDescriptor(\StepModel.date, order: .forward)])
        
        do {
            let results = try container.mainContext.fetch(descriptor)
            if results.count > 0 {
                results.forEach({$0.dateStr = dateFormatter.string(from: $0.date)})
                return results
            }
        } catch  {
            print(error.localizedDescription)
            
        }
        
        return []
        
    }
    
}
