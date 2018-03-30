//
//  WBUser.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/14.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBUser: NSObject {
    //
    @objc var id: Int64 = 0
    @objc var screen_name: String?
    @objc var profile_image_url: String?
    @objc var verified_type: Int = 0
    @objc var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }

}
