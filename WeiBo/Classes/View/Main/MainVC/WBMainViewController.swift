//
//  WBMainViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/16.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainViewController: UITabBarController {
    //
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //view.backgroundColor = UIColor.cz_random()

        //
        setupChildControllers()
        setupComposeButton()
        setupTimer()
        
        //
        setupNewFeatureViews()
        
        //
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: WBUserShouldLoginNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(userLogout), name: WBUserShouldLogoutNotification, object: nil)

    }
    
    deinit {
        //
        timer?.invalidate()
        
        //
        NotificationCenter.default.removeObserver(self)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    @objc private func composeStatus() {
        Print(self, "compose btn ")
        
        //
        let v = WBComposeTypeView.composeTypeView()
        
        v.show { [weak v] (clsName) in
            //
            guard let clsName = clsName,
                let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBComposeViewController.Type else {
                v?.removeFromSuperview()
                return
            }
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            
            self.present(nav, animated: true, completion: {
                //
                v?.removeFromSuperview()
            })
        }
    }
    
    //
    @objc private func userLogout(n: Notification) {
        //
        Print(self, "收到登出通知: \(n)")
        
    }
    
    ///
    @objc private func userLogin(n: Notification) {
        //
        Print(self, "收到登录通知: \(n)")
        
        //
        var when = DispatchTime.now()
        
        //
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "token 已过期，请重新登录！")
            
            //
            when = DispatchTime.now() + 2
        }
        
        //
        DispatchQueue.main.asyncAfter(deadline: when) {
            //
            SVProgressHUD.setDefaultMaskType(.clear)
            
            //
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }

}

extension WBMainViewController {
    //
    private func setupComposeButton() {
        //
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        //composeButton.backgroundColor = UIColor.red
        
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    private func setupChildControllers() {
        //
        let docStr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docStr as NSString).appendingPathComponent("main.json")
        
        var data = NSData(contentsOfFile: jsonPath)
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
            Print(self, "加载资源中文件：\(path!)")
        } else {
            Print(self, "加载泥沙盒中文件：\(jsonPath)")
        }
        
        //
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data) as? [[String: AnyObject]]
        else {
            return
        }

        //
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }

        viewControllers = arrayM
    }
    
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        //
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let visitorInfo = dict["visitorInfo"] as? [String: String],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type
        else {
            return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        
        vc.visitorInfoDictionary = visitorInfo
        
        //vc.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange],
                                     for: .selected)
        //vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
    }
}

///
extension WBMainViewController {
    //
    func setupTimer() {
        //
        timer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //
    @objc func updateTimer() {
        //
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //
        WBNetworkManager.shared.unreadCount { (count) in
            //
            Print(self, "\(Date().description) 定时器检测到 \(count) 条新微博！")

            //
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            //
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

///
extension WBMainViewController: UITabBarControllerDelegate {
    //
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //
        //print("将要切换到 viewController: \(viewController), view: \(viewController.view), title: \(String(describing: viewController.title))")
        
        //
        if let toIndex = childViewControllers.index(of: viewController) {
            if selectedIndex == toIndex {
                Print(self, "点击了首页")
                let nav = childViewControllers[0] as! UINavigationController
                let vc = nav.childViewControllers[0] as! WBHomeViewController
                if let rows = vc.tableView?.numberOfRows(inSection: 0) {
                    //
                    if rows > 0 {
                        //
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            //
                            let indexPath = IndexPath(row: 0, section: 0)
                            vc.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                            
                            //
                            //vc.tableView?.setContentOffset(CGPoint(x: 0, y: -vc.navigationBar.bounds.height),
                            //                               animated: true)
                        }
                        
                        //
                        vc.loadData()
                    }
                }
            }
        }
        
        // 若是点击到底层视图则不切换
        return !viewController.isMember(of: UIViewController.self)
    }
}



extension WBMainViewController {
    //
    private func setupNewFeatureViews() {
        //
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        
        //
        view.addSubview(v)
    }
    
    //
    private var isNewVersion: Bool {
        //
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        Print(self, currentVersion)
        
        //
        let path: String = ("version" as NSString).cz_appendDocumentDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        Print(self, sandboxVersion)

        //
        try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        //
        return currentVersion != sandboxVersion
    }
    
}















