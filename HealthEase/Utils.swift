//
//  Utils.swift
//
//  Created by Yang on on 18/2/2025.
//

import UIKit
 
let KScreeW = UIScreen.main.bounds.size.width
let KScreeH = UIScreen.main.bounds.size.height

var dateFor: DateFormatter = {
    let dateFor = DateFormatter()
    dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFor.locale = Locale.current
    return dateFor
}()

extension String? {
    func toDateWithDateFormat(dateFormat: String) -> Date? {
        // 2024-01-01 02:11:00
        dateFor.dateFormat = dateFormat
        dateFor.locale = Locale.current
        let date = dateFor.date(from: self ?? "")
        return date
        
    }
}

