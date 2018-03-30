//
//  UIBarButtonItem+Extension.swift
//  WeiBo
//
//  Created by 八月夏木 on 2017/12/21.
//  Copyright © 2017年 八月夏木. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: 默认 16 号
    ///   - target: target
    ///   - action: action
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            
            btn.sizeToFit()
            
            //print(btn)
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: btn)
    }

    
    
    
    
}









