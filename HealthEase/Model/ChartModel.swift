//
//  ChartModel.swift
//
//  Created by Yang on on 9/3/2025.
//

import Foundation


struct ChartModel : Hashable{
    var id: String = UUID().uuidString
    var xValue = ""
    var yValue = 0.0
    init(id: String = UUID().uuidString, xValue: String = "", yValue: Double = 0.0) {
        self.id = id
        self.xValue = xValue
        self.yValue = yValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ChartModel, rhs: ChartModel) -> Bool {
        return lhs.id == rhs.id
    }
}
