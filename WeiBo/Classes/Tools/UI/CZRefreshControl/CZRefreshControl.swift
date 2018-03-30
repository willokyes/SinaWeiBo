//
//  CZRefreshControl.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/25.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

//private let CZRefreshOffset: CGFloat = 60
private let CZRefreshOffset: CGFloat = 126

enum CZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

class CZRefreshControl: UIControl {
    //
    private weak var scrollView: UIScrollView?
    private lazy var refreshView: CZRefreshView = CZRefreshView.refreshView()
    
    //
    init() {
        super.init(frame: CGRect())
     
        //
        setupUI()
    }
    
    //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //
        setupUI()
    }
    
    //
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //
        guard let sv = newSuperview as? UIScrollView else { return }
        
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    deinit {
        Print(self)
    }

    override func removeFromSuperview() {
        //
        Print(self)
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")

        super.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //
        guard let sv = scrollView else { return }

        let height = -(sv.contentInset.top + sv.contentOffset.y)
        if height < 0 {
            return
        }
        
        if sv.isDragging {
            if height > CZRefreshOffset && refreshView.refreshState == .Normal {
                refreshView.refreshState = .Pulling
            } else if height <= CZRefreshOffset && refreshView.refreshState == .Pulling {
                refreshView.refreshState = .Normal
            }
        } else {
            if refreshView.refreshState == .Pulling {
                //
                beginRefreshing()
                
                //
                sendActions(for: .valueChanged)
            }
        }

        //
        self.frame = CGRect(x: 0, y: -(height+0), width: sv.bounds.width, height: height+0)

        //
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
    }

    //
    func beginRefreshing() {
        //
        guard let sv = scrollView else { return }
        
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        //
        refreshView.refreshState = .WillRefresh
        
        //
        var inset = sv.contentInset
        inset.top += CZRefreshOffset
        
        sv.contentInset = inset
        
        //
        refreshView.parentViewHeight = CZRefreshOffset
    }
    
    //
    func endRefreshing() {
        Print(self)
        
        guard let sv = scrollView else { return }
        
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        //
        refreshView.refreshState = .Normal
        
        //
        var inset = sv.contentInset
        inset.top -= CZRefreshOffset
        
        sv.contentInset = inset
    }
}

extension CZRefreshControl {
    //
    private func setupUI() {
        //
        backgroundColor = superview?.backgroundColor
        //backgroundColor = .red
        
        //
        addSubview(refreshView)
        
        //
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))

        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))

        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
    
    
    
}


















