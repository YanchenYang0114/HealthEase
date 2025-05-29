//
//  BadgesType.swift
//
//  Created by Yang on on 12/3/2025.
//

import Foundation

enum BadgesType : String{
    case perfect = "Perfect Month"
    case daily = "Daily Companion"
    
    case days3 = "3 days"
    case days7 = "7 days"
    case days15 = "15 days"
    case days30 = "30 days"
    case days90 = "90 days"
    case days180 = "180 days"
    case year = "1 year"
    
    
    var image:String {
        switch self {
        case .perfect:
            return "icon_perfect"
        case .daily:
            return "icon_daily"
        case .days3:
            return "icon_3day"
        case .days7:
            return "icon_7day"
        case .days15:
            return "icon_15day"
        case .days30:
            return "icon_30day"
        case .days90:
            return "icon_90day"
        case .days180:
            return "icon_180day"
        case .year:
            return "icon_1year"
        }
    }
    
}
