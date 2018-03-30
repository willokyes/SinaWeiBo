//
//  WBOAuthViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/25.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {
    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        //
        title = "登录新浪微博"
        view = webView
        view.backgroundColor = UIColor.red

        //
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        
        //
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        //
        if let cookies = HTTPCookieStorage.shared.cookies {
            Print(self, "webView Cookies: \n  \(cookies)")

            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        //
        Print(self, "webView 加载请求: \(urlString)")
        
        //let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

    @objc private func close() {
        //
        SVProgressHUD.dismiss()
        
        //
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        //
        let js1 = "document.getElementById('userId').value = 'domakeit@126.com';" +
                 "document.getElementById('passwd').value = 'qvbhwtusajd';"
        
        let js2 = "document.getElementById('userId').value = 'willokyes@163.com';" +
        "document.getElementById('passwd').value = 'fdsajklgh.9';"
        
        let js3 = "document.getElementById('userId').value = 'qvbhwtu@126.com';" +
        "document.getElementById('passwd').value = 'fdsajklgh.9';"
        
        let n = arc4random() % 3
        let js = (n == 0) ? js3 : ((n == 2) ? js2 : js1)
        
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
}

extension WBOAuthViewController: UIWebViewDelegate {
    //
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //
        Print(self, "webView 请求 url：\(request.url?.absoluteString ?? "")")
        
        //
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        //
        if request.url?.query?.hasPrefix("code=") == false {
            Print(self, "取消登录授权！")
            close()
            return false
        }
        
        //
        if let code = request.url?.query?.substring(from: "code=".endIndex) {
            //
            Print(self, "获取登录授权码：\(code)")
            //
            WBNetworkManager.shared.loadAccessToken(code: code, completion: { (isSuccess) in
                if !isSuccess {
                    Print(self, "获取 access token 失败！")
                    SVProgressHUD.showInfo(withStatus: "获取 access token 失败！")
                } else {
                    Print(self, "获取 access token 成功！")
                    SVProgressHUD.showInfo(withStatus: "获取 access token 成功！")
                    
                    //
                    NotificationCenter.default.post(name: WBUserLoginSucceedNotification, object: nil, userInfo: nil)
                    
                    //
                    self.close()
                }
            })
        }
        
        //
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        autoFill()
    }
    
}







