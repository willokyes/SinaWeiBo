//
//  WBWelcomeView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/6.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {
    //
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    //
    class func welcomeView() -> WBWelcomeView {
        //
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString) else { return }
        
        //
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
    }
    
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //
    }
    
    //
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //
        layoutIfNeeded()
        
        //
        bottomCons.constant = bounds.size.height - 200
        
        //
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                            self.layoutIfNeeded()
                        }) { (_) in
                            UIView.animate(withDuration: 1.0, animations: {
                                self.tipLabel.alpha = 1
                            }, completion: { (_) in
                                self.removeFromSuperview()
                            })
                        }
        
        //
        
        
    }
    
    
}


















