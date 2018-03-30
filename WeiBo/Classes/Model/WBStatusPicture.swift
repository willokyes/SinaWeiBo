//
//  WBStatusPicture.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/16.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBStatusPicture: NSObject {
    //
    @objc var thumbnail_pic: String? {
        didSet {
            large_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    @objc var large_pic: String?

    override var description: String {
        return yy_modelDescription()
    }
}

