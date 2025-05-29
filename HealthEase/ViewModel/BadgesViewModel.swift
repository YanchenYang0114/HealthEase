//
//  BadgesViewModel.swift
//
//  Created by Yang on on 10/3/2025.
//

import Foundation
import SwiftData

class BadgesViewModel: ObservableObject {
    static let shared = BadgesViewModel()
    var  container: ModelContainer!
    @Published var loadFinish = false
    
    @Published var lastDate = Date()
    @Published var yearList = [StepModel]()
    @Published var yearStart = Date()
    @Published var yearEnd = Date()
    
    @Published var isPerfectMonth = false //
    @Published var isDailyCompanion = false
    @Published var wearTimeDays = 0
    
    
    @Published var isDay3 = false
    @Published var isDay7 = false
    @Published var isDay15 = false
    @Published var isDay30 = false
    @Published var isDay90 = false
    @Published var isDay180 = false
    @Published var isYear = false
    @Published var meetingDays = 0
    let calendar = Calendar.current
    var dateFormatter: DateFormatter = {
        let dateFor = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd"
        dateFor.locale = Locale.current
        return dateFor
    }()
    
    init() {
        
    }
    
    func updateData()  {
        if yearList.isEmpty == false {
            return
        }
        
        Task {
            guard let lastDay = await HomeViewModel.shared.getLastData() else {
                return
            }
            let lastDate = self.calendar.date(byAdding: .day, value: -1, to: lastDay.date) ?? Date()
            DispatchQueue.main.async {
                self.lastDate = lastDate
            }
            
            let yearDataList = await queryDataList(lastDate: lastDate)
            //print("🟡 yearDataList count: \(yearDataList.count)")

            let yearDict =  Dictionary(grouping: yearDataList, by: {$0.dateStr})
            var array = Array( yearDict.values)
            array.sort(by: {$0.first!.date > $1.first!.date})
            //print("🟡 Grouped array count (days): \(array.count)")
            
            var isPerfectMonthTemp = true //
            var isDailyCompanionTemp = true
            var wearTimeDaysTem = 0
            for (index,values) in array.enumerated() {
                //一天的500步数
                let stepCount = values.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                //print("🟡 stepCount: \(stepCount)")
                if stepCount < 100 {
                    if index < 30 && isPerfectMonthTemp {
                        isPerfectMonthTemp = false
                    }
                    if index < 180 && isDailyCompanionTemp{
                        isDailyCompanionTemp = false
                    }
                    wearTimeDaysTem = index 
                    //有一天不达标往后都不达标
                    break
                }
                
            }
            print("---------------------")
            var isDay3Temp = true
            var isDay7Temp = true
            var isDay15Temp = true
            var isDay30Temp = true
            var isDay90Temp = true
            var isDay180Temp = true
            var isYearTemp = true
            var meetingDaysTemp = 0
            for (index,values) in array.enumerated() {
                // 每天运动5分钟是否达标(一份总80步才算运动)
                let totalSteps = values.reduce(0) { $0 + (Int($1.stepCount) ?? 0) }
                let minutes = totalSteps / 10
                //let minutes = values.reduce(0, {$0 + (((Int($1.stepCount) ?? 0) >= 80) ? 1: 0)})
                //print("🔹 Day \(index + 1) – minutes: \(minutes), steps: \(values.map { $0.stepCount })")
                if minutes < 10 {
                    if index < 3 && isDay3Temp {
                        isDay3Temp = false
                    }
                    
                    if index < 7 && isDay7Temp {
                        isDay7Temp = false
                    }
                    
                    if index < 15 && isDay15Temp {
                        isDay15Temp = false
                    }
                    
                    if index < 30 && isDay30Temp {
                        isDay30Temp = false
                    }
                    
                    if index < 90 && isDay90Temp {
                        isDay90Temp = false
                    }
                    
                    if index < 180 && isDay180Temp {
                        isDay180Temp = false
                        
                    }
                    
                    if index < 365 && isYearTemp {
                        isYearTemp = false
                    }
                    meetingDaysTemp = index
                    //有一天不达标往后都不达标
                    break
                }
            }
            
            //daily companion半年都有步数，
            let isPerfectMonth = isPerfectMonthTemp
            let isDailyCompanion = isDailyCompanionTemp
            let isDay3 = isDay3Temp
            let isDay7 = isDay7Temp
            let isDay15 = isDay15Temp
            let isDay30 = isDay30Temp
            let isDay90 = isDay90Temp
            let isDay180 = isDay180Temp
            let isYear = isYearTemp
            let wearTimeDays = wearTimeDaysTem
            let meetingDays = meetingDaysTemp
            DispatchQueue.main.async {
                self.loadFinish = true
                print("BadgesViewModel loadFinish")
                self.isPerfectMonth = isPerfectMonth
                self.isDailyCompanion = isDailyCompanion
                self.isDay3 = isDay3
                self.isDay7 = isDay7
                self.isDay15 = isDay15
                self.isDay30 = isDay30
                self.isDay90 = isDay90
                self.isDay180 = isDay180
                self.isYear = isYear
                self.wearTimeDays = wearTimeDays
                self.meetingDays = meetingDays
            }
            DispatchQueue.main.async {
                self.loadFinish = true
            }
            
        }
    }
    
    //最近一年数据
    @MainActor func queryDataList(lastDate:Date) -> [StepModel] {
        
        let startOfDay =  calendar.startOfDay(for: lastDate)
        let  end = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
        let  start = calendar.date(byAdding: .year, value: -1, to: end) ?? Date()
        
        self.yearStart = start
        self.yearEnd = end
        print("365__start:\(start)")
        print("365__end:\(end)")
        
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
