//
//  Helper.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 05.08.22.
//

import Foundation

class Helper {
    static let shared = Helper()
    
    func getDate(txt: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: txt) 
    }
}
