//
//  WBUserAccount.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/30.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

private let accountFile: NSString = "useraccount.json"

class WBUserAccount: NSObject {
    //
    @objc var access_token: String? //= "2.007usMgGCmAEaEaad0ff86a8vcho4E"
    //
    @objc var uid: String? //用户id
    //
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //
    @objc var expiresDate: Date?
    // 用户昵称
    @objc var screen_name: String?
    // 用户头像地址（大图），180×180像素
    @objc var avatar_large: String?
    //
    
    //
    override var description: String {
        return yy_modelDescription()
    }
    
    //
    override init() {
        //
        super.init()
        
        //
        guard let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data) else {
                return
        }
        
        //
        Print(self, "用户账户文件路径：\(path)")
        
        //
        yy_modelSet(withJSON: dict)
        
        //
        //expiresDate = Date(timeIntervalSinceNow: -3600*24*2)
        if expiresDate?.compare(Date()) != .orderedDescending {
            //
            Print(self, "账户过期！")
            
            //
            access_token = nil
            uid = nil
            
            //
            try? FileManager.default.removeItem(atPath: path)
        }
        
        //
        Print(self, "账户信息：\(self)")
    }
    
    //
    func saveAccount() {
        //
        var dict = self.yy_modelToJSONObject() as? [String: AnyObject] ?? [:]
        
        //
        dict.removeValue(forKey: "expires_in")
        
        //
        guard let data = try? JSONSerialization.data(withJSONObject: dict),
            let filePath = accountFile.cz_appendDocumentDir() else { return }
        
        (data as NSData).write(toFile: filePath, atomically: true)
    
        //
        Print(self, "网络用户账户保存成功：\(filePath)")
    }
}




















