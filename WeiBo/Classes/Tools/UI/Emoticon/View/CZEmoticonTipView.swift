//
//  CZEmoticonTipView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/27.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit
import pop

class CZEmoticonTipView: UIImageView {
    //
    private var preEmoticon: CZEmoticon?
    
    //
    var emoticon: CZEmoticon? {
        didSet {
            if preEmoticon == emoticon {
                return
            }
            
            preEmoticon = emoticon
            
            tipButton.setImage(emoticon?.image, for: .normal)
            tipButton.setTitle(emoticon?.emoji, for: .normal)

            //
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim?.fromValue = 10 + 50
            anim?.toValue = 10
            
            anim?.springBounciness = 15
            anim?.springSpeed = 20
            
            tipButton.layer.pop_add(anim, forKey: nil)
        }
    }
    
    //
    private lazy var tipButton = UIButton()
    
    //
    init() {
        //
        let bundle = CZEmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        //
        super.init(image: image)
        
        //
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        //
        tipButton.layer.anchorPoint.y = 0

        tipButton.frame = CGRect(x: 0, y: 10, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5

        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

















