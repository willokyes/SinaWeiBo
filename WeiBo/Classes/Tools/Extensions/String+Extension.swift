//
//  String+Extension.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/12.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

extension String {
    // get link and text from href string
    func cz_href() -> (link: String, text: String)? {
        //
        // <a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>
        
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
       
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSMakeRange(0, count)) else {
            return nil
        }
        
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        //
        return (link, text)
    }
}
























