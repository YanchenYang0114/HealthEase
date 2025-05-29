//
//  StepModel.swift
//
//  Created by Yang on on 1/3/2025.
//

import Foundation
import SwiftData
var dateFormatter1: DateFormatter = {
    let dateFor = DateFormatter()
    dateFor.dateFormat = "yyyy-MM"
    dateFor.locale = Locale.current
    return dateFor
}()

@Model
final class StepModel:Identifiable {
    var timestamp: String
    var id: String
    var stepCount: String
    var date: Date
    var dateStr: String = "" // temp use
    var monthStr: String {
        get {
            return dateFormatter1.string(from: date)
        }
    }
    init(timestamp: String? , id: String? , stepCount: String?, date: Date?) {
        self.timestamp = timestamp ?? ""
        self.id = id ?? UUID().uuidString
        self.stepCount = stepCount ?? "0"
        self.date = date ?? Date()
        
    }
}
