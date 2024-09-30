//
//  Date+Ext.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 20/03/24.
//

import UIKit

extension Date {
    
//    func convertToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        
//        return dateFormatter.string(from: self)
//    }
    
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
    
}
