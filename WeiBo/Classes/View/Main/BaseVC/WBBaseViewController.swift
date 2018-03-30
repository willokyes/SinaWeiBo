//
//  WBBaseViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/16.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {
    //
    var visitorInfoDictionary: [String: String]?
    
    //
    var tableView: UITableView?
    var refreshControl: CZRefreshControl?
    var isPullUp = false
    
    //
    var loadMoreView:UIView?
    
    //
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))

    lazy var navItem = UINavigationItem()
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupUI()
        
        //
        WBNetworkManager.shared.userLogon ? loadData() : ()
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: WBUserLoginSucceedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WBUserLoginSucceedNotification, object: nil)
    }
    
    //
    @objc func loadData() {
        refreshControl?.endRefreshing()
        tableView?.tableFooterView = nil
    }
    
    //
    private func setupUI() {
        //
        //view.backgroundColor = UIColor.cz_random()

        automaticallyAdjustsScrollViewInsets = false

        setupNavigationBar()
        
        WBNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    //
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.addSubview(tableView!)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //
        tableView?.dataSource = self
        tableView?.delegate = self
        
        //
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0,
                                               bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        //
        refreshControl = CZRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        // FIXME: nav color
        //tableView?.backgroundColor = UIColor.red
        //navigationBar.alpha = 0.6
        
        //
        loadMoreView = UIView(frame: CGRect(x: 0, y: (tableView?.contentSize.height)!, width: (tableView?.bounds.width)!, height: 60))
        loadMoreView?.autoresizingMask = UIViewAutoresizing.flexibleWidth
        loadMoreView?.backgroundColor = UIColor.orange
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityViewIndicator.color = UIColor.darkGray
        activityViewIndicator.frame = CGRect(x: loadMoreView!.frame.width/2 - activityViewIndicator.frame.width/2,
                                             y: loadMoreView!.frame.height/2 - activityViewIndicator.frame.height/2,
                                             width: activityViewIndicator.frame.width,
                                             height: activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        loadMoreView?.addSubview(activityViewIndicator)
        
        self.tableView?.tableFooterView = nil;
    }
}

// MARK: - 设置界面
extension WBBaseViewController {
    //
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
        
        //
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        //print(Unmanaged.passUnretained(navigationBar).toOpaque())
        //print(Unmanaged.passUnretained((navigationController?.navigationBar)!).toOpaque())
    }
    
    //
    private func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        //
        visitorView.visitorInfo = visitorInfoDictionary
        
        //
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        //
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
}

// MARK: - 访客视图监听方法
extension WBBaseViewController {
    //
    @objc private func login() {
        //
        Print(self, "发送用户登录通知")
        
        //
        NotificationCenter.default.post(name: WBUserShouldLoginNotification, object: nil)
    }
    
    //
    @objc private func loginSuccess(n: Notification) {
        //
        Print(self, "收到用户登录成功通知（成功获取到 access token）")
        
        //
        view = nil
        
        //
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func register() {
        Print(self, "用户注册")
    }
}

// MARK: - 表数据源方法
extension WBBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        let count = tableView.numberOfRows(inSection: section)
        
        //let visibleCount = tableView.visibleCells.count
        //print("--- willDisplay indexPath.row numberOfRows visibleCount：\(row, count, visibleCount)")
        
        if row == (count - 1) && !isPullUp {
            //
            Print(self, "上拉加载")
            
            isPullUp = true
            
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //
        return 10
    }
}

















