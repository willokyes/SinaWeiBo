//
//  WBNewFeatureView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/6.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {
    //
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterStatus(_ sender: Any) {
        //
        self.removeFromSuperview()
    }
    
    //
    class func newFeatureView() -> WBNewFeatureView {
        //
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    //
    override func awakeFromNib() {
        //
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "new_feature_\(i+1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(count+1) * rect.width, height: rect.height)
        
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.delegate = self
        
        //
        enterButton.isHidden = true
    }
    

}

extension WBNewFeatureView: UIScrollViewDelegate {
    //
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        //
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page == scrollView.subviews.count {
            self.removeFromSuperview()
        }
        
        //
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
        
        //
        //Print(self, "\(page) \(scrollView.contentOffset.x) \(scrollView.subviews.count)")
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        pageControl.isHidden = (page == scrollView.subviews.count)
        
        //
        enterButton.isHidden = true
        
        //
        //Print(self, page)
    }
    
    
}












