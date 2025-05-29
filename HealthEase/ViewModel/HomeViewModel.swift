//
//  DataViewModel.swift
//
//  Created by Yang on on 3/1/2025.
//

import Foundation
import SwiftData

class HomeViewModel: ObservableObject {
    static let shared = HomeViewModel()
    var  container: ModelContainer!
    @Published var stepModelList : [StepModel] = []
    
    @Published var nearDay = Date()
    @Published var nearDayList = [StepModel]()
    @Published var nearDaySteps = 0
    @Published var nearDayMinutes = 0
    
    init() {
       
    }
    
    func updateData() {
        Task {
            let nearDayList = await querynearDayList()
            DispatchQueue.main.async {
                self.nearDayList = nearDayList
                self.nearDaySteps = self.nearDayList.reduce(0, {$0 + (Int($1.stepCount) ?? 0)})
                self.nearDayMinutes = self.nearDayList.reduce(0, {$0 + (((Int($1.stepCount) ?? 0) >= 80) ? 1: 0)})
            }
        }
    }
    
    
    
    @MainActor func querynearDayList() -> [StepModel] {
        if let lastData = getLastData() {
            nearDay = Calendar.current.date(byAdding: .day, value: -1, to: lastData.date)!
            
            var start =  Calendar.current.startOfDay(for: nearDay)
             
            nearDay = start
            guard let end = Calendar.current.date(byAdding: .day, value: 1, to: start) else { return [] }
           
            let predicate =  #Predicate<StepModel> {
                $0.date >= start && $0.date < end
            }
            let descriptor = FetchDescriptor<StepModel>(predicate: predicate, sortBy: [SortDescriptor(\StepModel.date, order: .forward)])
        
            do {
               let results = try container.mainContext.fetch(descriptor)
                if results.count > 0 {
                    
                    return results
                }
            } catch  {
                print(error.localizedDescription)
                
            }
            return []
        }
        return []
  
    }
    
    @MainActor func getLastData() -> StepModel?{
        var descriptor = FetchDescriptor<StepModel>(sortBy: [SortDescriptor(\StepModel.date, order: .reverse)])
        descriptor.fetchLimit = 1
        descriptor.fetchOffset = 0
        
        do {
           let results = try container.mainContext.fetch(descriptor)
            return results.first
        } catch  {
            print(error.localizedDescription)
            
        }
        return nil
    }
    
}
