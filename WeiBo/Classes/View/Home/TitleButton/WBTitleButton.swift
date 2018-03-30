//
//  WBTitleButton.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/6.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    //
    init(title: String?) {
        super.init(frame: CGRect())
        
        //
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title! + " ", for: .normal)
            
            //
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        setTitleColor(.darkGray, for: .normal)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        //
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //
        //Print(self, "布局标题按钮子视图")
        
        //
        guard let titleLabel = titleLabel, let imageView = imageView else { return }
        
        //
        if titleLabel.frame.origin.x > imageView.frame.origin.x {
            titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
            imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        }
    }
}
