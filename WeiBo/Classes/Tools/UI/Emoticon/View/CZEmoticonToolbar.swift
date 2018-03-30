//
//  CZEmoticonToolbar.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/22.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

///
protocol CZEmoticonToolbarDelegate: NSObjectProtocol {
    //
    func emoticonToolbar(_ toolbar: CZEmoticonToolbar, didSelectItemAt index: Int)
    
}

class CZEmoticonToolbar: UIView {
    //
    weak var delegate: CZEmoticonToolbarDelegate?
    
    //
    var selectedIndex: Int = 0 {
        didSet {
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            
            (subviews[selectedIndex] as? UIButton)?.isSelected = true
        }
    }
    
    //
    override func awakeFromNib() {
        //
        setupUI()
    }
    
    //
    override func layoutSubviews() {
        //
        let count = CGFloat(subviews.count)
        let width = bounds.width / count
        let rect = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        
        for (i, v) in subviews.enumerated() {
            v.frame = rect.offsetBy(dx: width * CGFloat(i), dy: 0)
        }
    }

    //
    @objc func clickGroupItem(button: UIButton) {
        //
        let tag = button.tag
        
        delegate?.emoticonToolbar(self, didSelectItemAt: tag)
    }
}

extension CZEmoticonToolbar {
    //
    func setupUI() {
        //
        backgroundColor = .blue
        
        //
        let manager = CZEmoticonManager.shared
        
        for (i, p) in manager.packages.enumerated() {
            //
            let btn = UIButton()
            
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            btn.setTitleColor(.white, for: .normal)
            btn.setTitleColor(.darkGray, for: .highlighted)
            btn.setTitleColor(.darkGray, for: .selected)
            
            //
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5,
                                     left: size.width * 0.5,
                                     bottom: size.height * 0.5,
                                     right: size.width * 0.5)
            
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            btn.setBackgroundImage(image, for: .normal)
            btn.setBackgroundImage(imageHL, for: .highlighted)
            btn.setBackgroundImage(imageHL, for: .selected)

            btn.tag = i
            btn.addTarget(self, action: #selector(clickGroupItem), for: .touchUpInside)
            
            addSubview(btn)
        }
        
        selectedIndex = 0
    }
}









