//
//  Date+Extension.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/26.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()
private let calendar = Calendar.current

///
extension Date {
    //
    static func cz_dateString(delta: TimeInterval) -> String {
        //
        let date = Date(timeIntervalSinceNow: delta)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        return dateFormatter.string(from: date)
    }
    
    //
    // Fri Mar 30 12:06:28 +0800 2018
    static func cz_sinaDate(string: String) -> Date? {
        //
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return dateFormatter.date(from: string)
    }
    
    //
    var cz_dateDescription: String {
        //
        if calendar.isDateInToday(self) {
            let delta = -Int(timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            } else if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        //
        var fmt = " HH:mm"

        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let thisYear = calendar.component(.year, from: Date())
            let year = calendar.component(.year, from: self)
            
            if year != thisYear {
                fmt = "yyyy-MM-dd"
            }
        }

        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
    
}










