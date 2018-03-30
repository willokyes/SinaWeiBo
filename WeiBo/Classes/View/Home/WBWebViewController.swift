//
//  WBWebViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/18.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBWebViewController: WBBaseViewController {
    //
    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    //
    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else { return  }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        
    }

    //
    override func setupTableView() {
        //
        navItem.title = "网页"
        //navItem.backBarButtonItem = 
        
        //
        view.insertSubview(webView, belowSubview: navigationBar)

        //
        webView.scrollView.contentInset.top = navigationBar.bounds.height
    }
    
    
    
}
