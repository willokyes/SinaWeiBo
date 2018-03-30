//
//  CZRefreshView.swift
//  RefreshControl
//
//  Created by 八月夏木 on 2018/2/28.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class CZRefreshView: UIView {
    //
    @IBOutlet weak var tipIcon: UIImageView?
    @IBOutlet weak var tipLabel: UILabel?
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    var parentViewHeight: CGFloat = 0
    
    //
    var refreshState: CZRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                tipIcon?.isHidden = false
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = .identity
                    self.tipLabel?.text = "下拉刷新"
                }
                indicator?.stopAnimating()
            case .Pulling:
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(.pi + 0.001))
                    self.tipLabel?.text = "释放更新"
                }
            case .WillRefresh:
                tipLabel?.text = "加载中..."
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    //
    class func refreshView() -> CZRefreshView {
        //let nib = UINib(nibName: "CZRefreshView", bundle: nil)
        //let nib = UINib(nibName: "CZHumanRefreshView", bundle: nil)
        let nib = UINib(nibName: "CZMeituanRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CZRefreshView
    }
}
