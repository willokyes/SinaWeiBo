//
//  WBHomeViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/16.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import UIKit

private let originalCellId = "originalCellId"
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(browsePhoto),
                                               name: WBStatusCellBrowsePhotoNotification,
                                               object: nil)
    }
    
    //
    @objc func browsePhoto(n: Notification) {
        //
        guard let selectedIndex = n.userInfo?[WBStatusCellBrowsePhotoSelectedIndexKey] as? Int,
            let urls = n.userInfo?[WBStatusCellBrowsePhotoURLsKey] as? [String],
            let imageViews = n.userInfo?[WBStatusCellBrowsePhotoImageViewsKey] as? [UIImageView]
        else { return }
        
        //
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex,
                                                       urls: urls,
                                                       parentImageViews: imageViews)
        present(vc, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WBStatusCellBrowsePhotoNotification, object: nil)
    }
    
    @objc private func showFriends()  {
        //
        Print(self, CZSQLiteManager.shared)
        
        //
        var nx = next
        while nx != nil {
            //Print(self, nx)
            
            nx = nx?.next
        }
        
        let vc = WBDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logout() {
        //
        WBNetworkManager.shared.userAccount.access_token = nil
        statusListViewModel.statusList.removeAll()
        
        //
        let superview = view.superview
        
        view = nil
        
        superview?.addSubview(view)
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        //
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        //
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登出", target: self, action: #selector(logout))
        
        //
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        
        //
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)

        //
        //tableView?.rowHeight = UITableViewAutomaticDimension
        //tableView?.estimatedRowHeight = 100
        
        tableView?.separatorStyle = .none
        
        //
        setupNavTitle()
    }
    
    func setupNavTitle() {
        //
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc func clickTitleButton(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
    
    //
    private lazy var statusListViewModel = WBStatusListViewModel()
    
    override func loadData() {
        //
        if isPullUp {
            Print(self, "开始上拉加载数据！")
            tableView?.tableFooterView = loadMoreView
        } else {
            Print(self, "开始下拉刷新数据！")
            refreshControl?.beginRefreshing()
        }
        
        //
        self.statusListViewModel.loadStatuses(isPullUp: self.isPullUp) { (isSuccess, shouldRefresh) in
            //
            Print(self, "加载数据结束，isSuccess: \(isSuccess)")
            
            //
            if self.isPullUp {
                self.isPullUp = false
                self.tableView?.tableFooterView = nil
            } else {
                self.refreshControl?.endRefreshing()
                
                //
                self.tabBarItem.badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            
            //
            if shouldRefresh {
                Print(self, "刷新表格")
                self.tableView?.reloadData()
            }
        }
    }
}

/// MARK - 表视图数据源方法
extension WBHomeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let viewModel = statusListViewModel.statusList[indexPath.row]
        
        let cellId = viewModel.status.retweeted_status != nil ? retweetedCellId : originalCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell

        cell.viewModel = viewModel
        
        //
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //
        let viewModel = statusListViewModel.statusList[indexPath.row]
        
        //Print(self, "第 \(indexPath.row) 行高：\(viewModel.rowHeight)")
        
        return viewModel.rowHeight
    }
}

///
extension WBHomeViewController: WBStatusCellDelegate {
    //
    func statusCellDidSelectedLinkText(statusCell: WBStatusCell, linkText: String) {
        //
        Print(self)
        
        //
        let vc = WBWebViewController()
        vc.urlString = linkText
        navigationController?.pushViewController(vc, animated: true)
    }
}















