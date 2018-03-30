//
//  WBVisitorView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/2.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    
    //
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //
        Print(self, nil)
        
        //
        if isUserInteractionEnabled == false || isHidden == true || alpha <= 0.01 {
            return nil
        }
        
        if self.point(inside: point, with: event) == false  {
            return nil
        }
        
        for subview in subviews.reversed() {
            //
            let hitPoint = convert(point, to: subview)
            let hitView = subview.hitTest(hitPoint, with: event)
            if hitView != nil {
                return hitView
            }
        }
        
        return self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    // MARK: setup visitor view
    ///
    ///
    /// - Parameter dict: [imageName: message]
    var visitorInfo: [String: String]? {
        didSet {
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            tipLabel.text = message
            
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            //
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * Double.pi
        anim.repeatCount = Float.greatestFiniteMagnitude
        anim.duration = 15
        anim.isRemovedOnCompletion = false
        
        iconView.layer.add(anim, forKey: nil)
    }
    
    private lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    private lazy var maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    private lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))

    private lazy var tipLabel: UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    
    lazy var registerButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
}

extension WBVisitorView {
    
    func setupUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //
        tipLabel.textAlignment = .center
        
        //
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: NSLayoutAttribute.centerX,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: NSLayoutAttribute.centerY,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self,
                                         attribute: NSLayoutAttribute.centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        
        //
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: NSLayoutAttribute.centerX,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: iconView,
                                         attribute: NSLayoutAttribute.centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: NSLayoutAttribute.centerY,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: iconView,
                                         attribute: NSLayoutAttribute.centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //
        let margin: CGFloat = 20.0
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        
        //
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        //
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : Any]
        let metrics = ["spacing": 20]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|",
                                                     options: [],
                                                     metrics: nil,
                                                     views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
                                                      options: [],
                                                      metrics: metrics,
                                                      views: viewDict))
        
    }
    
    
    
}










