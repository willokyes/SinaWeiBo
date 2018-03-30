//
//  WBDemoViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/19.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    @objc private func showNext() {
        let vc = WBDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        //
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
    
    

}




