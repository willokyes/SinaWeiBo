//
//  Bundle+Extension.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/16.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import Foundation

extension Bundle {
    //    func namespace() -> String {
    //        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    //    }
    
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
