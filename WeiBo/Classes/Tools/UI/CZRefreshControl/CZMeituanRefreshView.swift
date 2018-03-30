//
//  CZMeituanRefreshView.swift
//  RefreshControl
//
//  Created by 八月夏木 on 2018/3/2.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class CZMeituanRefreshView: CZRefreshView {
    //
    @IBOutlet weak var buildingIconView: UIImageView!
    @IBOutlet weak var earthIconView: UIImageView!
    @IBOutlet weak var kangarooIconView: UIImageView!
    
    //
    override var parentViewHeight: CGFloat {
        didSet {
            //
            if parentViewHeight < 23 {
                return
            }
            
            let scale: CGFloat
            
            // 126 --> 1
            // 23 -- > 0.2
            if parentViewHeight > 126 {
                scale = 1
            } else {
                scale = (parentViewHeight - 23) / (126 - 23)
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    //
    override func awakeFromNib() {
        //
        if let bImage1 = UIImage(named: "icon_building_loading_1"),
            let bImage2 = UIImage(named: "icon_building_loading_2") {
            buildingIconView.image = UIImage.animatedImage(with: [bImage1, bImage2], duration: 0.3)
        }
        
        //
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = -2 * Float.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        
        earthIconView.layer.add(anim, forKey: nil)
        earthIconView.isHidden = false

        //
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        kangarooIconView.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height - 23)
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        if let kImage1 = UIImage(named: "icon_small_kangaroo_loading_1"),
            let kImage2 = UIImage(named: "icon_small_kangaroo_loading_2") {
            kangarooIconView.image = UIImage.animatedImage(with: [kImage1, kImage2], duration: 0.3)
        }
    }
    
}










