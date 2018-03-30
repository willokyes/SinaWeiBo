//
//  AppDelegate.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/16.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()
        
        //
        setupAddtions()
        
        //
        //loadAppInfo()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

///
extension AppDelegate {
    //
    private func setupAddtions() {
        //
        SVProgressHUD.setMaximumDismissTimeInterval(1)

        //
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        //
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (isSuccess, error) in
                Print(self, "获取用户通知中心授权" + (isSuccess ? "成功" : "失败"))
            }
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                                  categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }

        //
        
    }
}

///
extension AppDelegate {
    //
    private func loadAppInfo() {
        //
        WBNetworkManager.shared.mainVCData { (list, isSuccess) in
            guard let list = list else {
                Print(self, "获取服务器 main.json 文件失败！")
                return
            }
            
            //
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let path = (docDir as NSString).appendingPathComponent("main.json")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: list, options: [JSONSerialization.WritingOptions.prettyPrinted])
            (jsonData as NSData).write(toFile: path, atomically: true)
            
            Print(self, "获取服务器 main.json 文件成功，并保存到：\(path)")
        }
    }
    
    //
    private func loadAppInfo2() {
        DispatchQueue.global().async {
            //
            let url = URL(string: "http://192.168.64.2/php/main.json")
            let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                     .userDomainMask,
                                                                     true)[0]
                    let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
                    let location = URL(fileURLWithPath: jsonPath)
                    try! data.write(to: location, options: .atomic)
                    Print(self, "应用程序加载完毕 \(jsonPath)")
                    //print(error ?? "success")
                } else {
                    //print(error!)
                }
            })
            dataTask.resume()
        }
    }
    
    //
    private func loadAppInfo0() {
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            let data = NSData(contentsOf: url!)
            
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                             .userDomainMask,
                                                             true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕 \(jsonPath)")
        }
    }
    
    
}





















