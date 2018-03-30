//
//  WBComposeTypeView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/5.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit
import pop

class WBComposeTypeView: UIView {
    //
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var closeBtnCenterXCons: NSLayoutConstraint!
    
    @IBOutlet weak var returnBtnCenterXCons: NSLayoutConstraint!
    
    @IBOutlet weak var returnButton: UIButton!
    
    //
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    var completionBlock: ((String?)->())?
    
    //
    class func composeTypeView() -> WBComposeTypeView {
        //
        let nib = UINib.init(nibName: "WBComposeTypeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        v.frame = UIScreen.main.bounds
        
        //
        v.layoutIfNeeded()
        
        //
        v.setupUI()
        
        return v
    }
    
    //
    func show(completion: @escaping (String?)->()) {
        //
        completionBlock = completion
        
        //
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        
        //
        showCurrentView()
    }
    
    //
    @objc func clickButton(selectedButton: WBComposeTypeButton) {
        //
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated() {
            //
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            let scale = (btn == selectedButton ? 2: 0.2)
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            
            btn.pop_add(scaleAnim, forKey: nil)
            
            //
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            //
            if i == 0 {
                alphaAnim.completionBlock = { _, _ in
                    self.completionBlock?(selectedButton.clsName)
                }
            }
        }
    }

    //
    @objc func clickMore() {
        //
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //
        returnButton.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        
        closeBtnCenterXCons.constant += margin
        returnBtnCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func clickClose(_ sender: Any) {
        hideButtons()
    }
    
    @IBAction func clickReturn(_ sender: Any) {
        //
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //
        closeBtnCenterXCons.constant = 0
        returnBtnCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { (_) in
            self.returnButton.alpha = 1
            self.returnButton.isHidden = true
        }
    }
}

///
private extension WBComposeTypeView {
    //
    func setupUI()  {
        //
        let rect = scrollView.bounds
        
        for i in 0..<2 {
            //
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0))
            
            //
            addButtons(v: v, idx: i * 6)
            
            //
            scrollView.addSubview(v)
        }
        
        //
        scrollView.contentSize = CGSize(width: rect.width * 2, height: 0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    //
    func addButtons(v: UIView, idx: Int) {
        //
        let count = 6
        for i in idx..<(idx + count) {
            //
            if i >= buttonsInfo.count {
                break
            }
            
            //
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"], let title = dict["title"] else {
                continue
            }
            
            let button = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            
            v.addSubview(button)
            
            //
            if let actionName = dict["actionName"] {
                button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            //
            button.clsName = dict["clsName"]
        }
        
        //
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - btnSize.width * 3) / 4
        
        for (i, btn) in v.subviews.enumerated() {
            //
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            let y = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
    
}

/// animation
private extension WBComposeTypeView {
    //
    private func showCurrentView() {
        //
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        
        pop_add(anim, forKey: nil)
        
        //
        showButtons()
    }
    
    //
    private func showButtons() {
        //
        let v = scrollView.subviews[0]
        
        for (i, btn) in v.subviews.enumerated() {
            //
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y + 350
            anim.toValue = btn.center.y
            anim.springBounciness = 8
            anim.springSpeed = 10
            
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            //Print(self, "\(anim.beginTime, CACurrentMediaTime())")
            
            btn.pop_add(anim, forKey: nil)
        }
    }
    
    //
    func hideButtons() {
        //
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //
        for (i, btn) in v.subviews.reversed().enumerated() {
            //
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
            
            //
            if i == v.subviews.count - 1 {
                anim.completionBlock = { _, _ in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    //
    private func hideCurrentView() {
        //
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.5
        
        pop_add(anim, forKey: nil)
        
        //
        anim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
}












