//
//  WBNetworkManager+Extension.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/10.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

// MARK - 封装新浪微博的网络请求方法
extension WBNetworkManager {
    
    /// 获取当前登录用户及其所关注（授权）用户的最新微博
    ///
    /// - Parameter completion:
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping ([[String: Any]]?, Bool) -> ()) {
        //
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //
        let params = ["since_id": "\(since_id)",
                      "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
        
        //
        tokenRequest(URLString: urlString, parameters: params) { (json, isSuccess) in
            if let jsonDict = json as? [String: Any] {
                let list = jsonDict["statuses"] as? [[String: Any]]
                completion(list, isSuccess)
            } else {
                completion(nil, isSuccess)
            }
        }
    }
    
    //
    func unreadCount(completion: @escaping (Int)->()) {
        //
        guard let uid = userAccount.uid else { return }
        
        //
        let urltString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        
        //
        tokenRequest(URLString: urltString, parameters: params) { (json, isSuccess) in
            let dict = json as? [String: Any]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
    
    //
    func mainVCData(completion: @escaping ([[String: Any]]?, Bool)->()) {
        //
        let urlString = "http://192.168.64.2/php/main.json"
        
        //
        request(URLString: urlString, parameters: nil) { (json, isSuccess) in
            let list = json as? [[String : Any]]
            completion(list, isSuccess)
        }
    }
}

///
extension WBNetworkManager {
    //
    func loadUserInfo(completion: @escaping (Any?)->()) {
        //
        guard let uid = userAccount.uid else { return }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid": uid]
        
        tokenRequest(URLString: urlString, parameters: params) { (dict, isSuccess) in
            //
            Print(self, "通过 access token 获取到用户个人信息：\(urlString)")

            //
            completion(dict)
        }
    }
}

///
extension WBNetworkManager {
    //
    func loadAccessToken(code: String, completion: @escaping (Bool)->()) {
        //
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        request(method: .POST, URLString: urlString, parameters: params) { (json, isSuccess) in
            //
            self.userAccount.yy_modelSet(withJSON: json ?? [:])
            
            //
            Print(self, "通过授权码获取到 access token 信息 [\(urlString)]：\n \(self.userAccount)")
            
            //
            self.loadUserInfo(completion: { (dict) in
                //
                self.userAccount.yy_modelSet(withJSON: dict ?? [:])
                
                //
                Print(self, "用户个人信息为：\n \(self.userAccount)")
                
                //
                self.userAccount.saveAccount()
                
                //
                completion(isSuccess)
            })
        }
    }
}

///
extension WBNetworkManager {
    //
    func postStatus(text: String, image: UIImage?, completion: @escaping ([String: AnyObject]?, Bool)->()) -> () {
        //
        //let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        let params = ["status": text]
        
        var name: String?
        var data: Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        tokenRequest(method: .POST, URLString: urlString, parameters: params, name: name, data: data) { (json, isSuccess) in
            completion(json as? [String: AnyObject], isSuccess)
        }
    }
}




































