//
//  WeiBoCommon.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/25.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

let WBAppKey = "4197435714"
let WBAppSecret = "b3551e983ea8ac4bb40041785c5ab3f4"
let WBRedirectURI = "http://baidu.com"

let WBUserShouldLoginNotification = NSNotification.Name("WBUserShouldLoginNotification")
let WBUserLoginSucceedNotification = NSNotification.Name("WBUserLoginSucceedNotification")
//let WBUserShouldLogoutNotification = NSNotification.Name("WBUserShouldLogoutNotification")

//
let WBStatusPictureViewOutterMargin = CGFloat(12)
let WBStatusPictureViewInnerMargin = CGFloat(3)
let WBStatusPictureViewWidth = UIScreen.cz_screenWidth() - WBStatusPictureViewOutterMargin * 2
let WBStatusPictureViewItemWidth = (WBStatusPictureViewWidth - WBStatusPictureViewInnerMargin * 2) / 3

//
let WBStatusCellBrowsePhotoNotification = NSNotification.Name("WBStatusCellBrowsePhotoNotification")
let WBStatusCellBrowsePhotoURLsKey = NSNotification.Name("WBStatusCellBrowsePhotoURLsKey")
let WBStatusCellBrowsePhotoSelectedIndexKey = NSNotification.Name("WBStatusCellBrowsePhotoSelectedIndexKey")
let WBStatusCellBrowsePhotoImageViewsKey = NSNotification.Name("WBStatusCellBrowsePhotoImageViewsKey")




















//
func Print(_ cls: Any,  _ any: Any? = nil, _ funcName: String = #function) {
    if let any = any {
        print("\n\(Date().description): \(type(of: cls)) 类: \(funcName) 方法：" + "\(any)")
    } else {
        print("\n\(Date().description): \(type(of: cls)) 类: \(funcName) 方法：😉")
    }
}


// . thumbnail . bmiddle . or480 . wap720 . woriginal . large .  wap360
//  3KB          67KB       29KB    75KB        75KB    116KB
//  59kb          916                 1926         7173  9089


