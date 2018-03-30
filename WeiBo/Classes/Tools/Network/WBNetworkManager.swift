//
//  WBNetworkManager.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/9.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit
import AFNetworking

// https://api.weibo.com/oauth2/authorize?client_id=4197435714&redirect_uri=http://www.baidu.com
// https://www.baidu.com/?code=68e0412533eb70b95bbc6303aba39ce6
// 2.007usMgGCmAEaEaad0ff86a8vcho4E
// domakeit@126.com

//
enum WBHTTPMethod {
    case GET
    case POST
}

class WBNetworkManager: AFHTTPSessionManager {
    //
    static let shared: WBNetworkManager = {
        //
        let instance = WBNetworkManager()
        
        //
        //instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        instance.requestSerializer.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        //
        return instance
    }()
    
    //
    lazy var userAccount = WBUserAccount()
    
    //
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    //
    func tokenRequest(method: WBHTTPMethod = .GET,
                      URLString: String,
                      parameters: [String: Any]?,
                      name: String? = nil,
                      data: Data? = nil,
                      completion: @escaping ((Any?, Bool)->())) {
        //
        guard let token = userAccount.access_token else {
            //
            print("没有 token ，需要登录！")

            //
            NotificationCenter.default.post(name: WBUserShouldLoginNotification, object: nil, userInfo: nil)
            
            //
            completion(nil, false)
            return
        }
        
        var parameters = parameters
        if parameters == nil {
            parameters = [String: Any]()
        }
        
        parameters!["access_token"] = token
        
        //
        if let name = name, let data = data {
            upload(URLString: URLString, parameters: parameters, name: name, data: data, completion: completion)
        }
        else {
            request(method: method, URLString: URLString, parameters: parameters, completion: completion)
        }
    }
    
    //
    func upload(URLString: String,
                parameters: [String: Any]?,
                name: String,
                data: Data,
                completion: @escaping ((Any?, Bool)->())) {
        //
        let constructingBodyWith = { (formData: AFMultipartFormData) -> () in
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
        }
        
        let success = { (task: URLSessionDataTask?, json: Any?) -> () in
            completion(json, true)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            if let statusCode = (task?.response as? HTTPURLResponse)?.statusCode {
                //if (statusCode == 403 || statusCode == 400) {
                if (statusCode != 200) {
                    //
                    Print(self, "请求失败，Token 错误 或 已过期 或 其它错误！[ \(URLString) ]")
                    
                    //
                    NotificationCenter.default.post(name: WBUserShouldLoginNotification, object: "bad token", userInfo: nil)
                }
            }
            
            Print(self, "网络请求错误！\(error)")
            completion(nil, false)
        }
        
        //
        post(URLString, parameters: parameters, constructingBodyWith: constructingBodyWith, progress: nil, success: success, failure: failure)
    }
    
    //
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - Parameters:
    ///   - method: GET / POST
    ///   - URLString: The URL string used to create the request URL.
    ///   - parameters: The parameters to be encoded according to the client request serializer.
    ///   - completion: 完成回调 [ json(数组/字典)，是否成功 ]
    func request(method: WBHTTPMethod = .GET,
                 URLString: String,
                 parameters: [String: Any]?,
                 completion: @escaping ((Any?, Bool)->())) {
        //
        var str: String = URLString + "?"
        for dict in parameters ?? [:] {
            str = str + "\(dict.key)" + "=\(dict.value)&"
        }

        str.remove(at: str.index(before: str.endIndex))
        Print(self, "\(method) 请求地址：\n  \(str)")
        
        //
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(json, true)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            if let statusCode = (task?.response as? HTTPURLResponse)?.statusCode {
                //if (statusCode == 403 || statusCode == 400) {
                if (statusCode != 200) {
                    //
                    Print(self, "请求失败，Token 错误 或 已过期 或 其它错误！[ \(URLString) ]")
                    
                    //
                    NotificationCenter.default.post(name: WBUserShouldLoginNotification, object: "bad token", userInfo: nil)
                }
            }
            
            Print(self, "网络请求错误！\(error)")
            completion(nil, false)
        }

        //
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    

}














