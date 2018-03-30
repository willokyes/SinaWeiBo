//
//  WBStatus.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/10.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBStatus: NSObject {
    //
    @objc var id: Int64 = 0
    @objc var text: String?
    @objc var user: WBUser?
    
    //
    @objc var reposts_count: Int = 0
    @objc var comments_count: Int = 0
    @objc var attitudes_count: Int = 0
    
    //
    @objc var pic_urls: [WBStatusPicture]?
    
    //
    @objc var retweeted_status: WBStatus?
    
    //
    @objc var created_at: String? {
        didSet {
            createdDate = Date.cz_sinaDate(string: created_at ?? "")
        }
    }
    
    //
    @objc var createdDate: Date?
    
    //
    @objc var source: String? {
        didSet {
            source = "来自 " + (source?.cz_href()?.text ?? "")
        }
    }
    
    @objc class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": WBStatusPicture.self]
    }
    
    //
    override var description: String {
        return yy_modelDescription()
    }
}
