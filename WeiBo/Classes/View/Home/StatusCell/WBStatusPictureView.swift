//
//  WBStatusPictureView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/16.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    //
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    var viewModel: WBStatusViewModel? {
        didSet {
            //
            calcImageViewSize()
            
            //
            urls = viewModel?.picURLs
        }
    }
    
    private func calcImageViewSize() {
        //
        if viewModel?.picURLs?.count == 1 {
            //
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: WBStatusPictureViewOutterMargin,
                             width: viewSize.width,
                             height: viewSize.height - WBStatusPictureViewOutterMargin)
        } else {
            //
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: WBStatusPictureViewOutterMargin,
                             width: WBStatusPictureViewItemWidth,
                             height: WBStatusPictureViewItemWidth)
        }
        
        //
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    //
    private var urls: [WBStatusPicture]? {
        didSet {
            //
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            let ivs = subviews as! [UIImageView]
            for url in urls ?? [] {
                //
                guard let urlStr = url.thumbnail_pic else { continue }

                let iv = ivs[index]

                iv.cz_setImage(urlString: urlStr, placeholderImage: nil)
                iv.isHidden = false
                
                iv.subviews[0].isHidden = ((urlStr as NSString).pathExtension != "gif")
                
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                index += 1
            }
        }
    }

    //
    override func awakeFromNib() {
        setupUI()
    }
    
    func resetImageViews() {
        //
        let ivs = subviews as! [UIImageView]
        
        for iv in ivs {
            iv.image = nil
        }
    }
    
    //
    @objc func tapImageView(tap: UITapGestureRecognizer) {
        //
        guard let picURLs = viewModel?.picURLs,
            let tappedView = tap.view
        else { return }
        
        //
        let urls = (picURLs as NSArray).value(forKey: "large_pic") as! [String]
        
        //
        var selectedIndex = tappedView.tag
        
        if urls.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        //
        var imageViews = [UIImageView]()
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViews.append(iv)
            }
        }
        
        //
        NotificationCenter.default.post(name: WBStatusCellBrowsePhotoNotification,
                                        object: nil,
                                        userInfo: [WBStatusCellBrowsePhotoURLsKey: urls,
                                                   WBStatusCellBrowsePhotoSelectedIndexKey: selectedIndex,
                                                   WBStatusCellBrowsePhotoImageViewsKey: imageViews])
    }
}

extension WBStatusPictureView {
    //
    private func setupUI() {
        //
        backgroundColor = superview?.backgroundColor

        //
        clipsToBounds = true
        
        //
        let rect = CGRect(x: 0,
                          y: WBStatusPictureViewOutterMargin,
                          width: WBStatusPictureViewItemWidth,
                          height: WBStatusPictureViewItemWidth)
        let count = 3
        
        for i in 0..<count*count {
            //
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.backgroundColor = UIColor.cz_color(withHex: 0xEEEEEE)
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            
            let dx = col * (WBStatusPictureViewItemWidth + WBStatusPictureViewInnerMargin)
            let dy = row * (WBStatusPictureViewItemWidth + WBStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: dx, dy: dy)
            
            addSubview(iv)
            
            //
            iv.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            iv.addGestureRecognizer(tap)
            
            iv.tag = i
            
            //
            addGifView(imageView: iv)
        }
    }
    
    //
    private func addGifView(imageView: UIImageView) {
        //
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        
        imageView.addSubview(gifImageView)
        
        //
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addConstraint(NSLayoutConstraint(item: gifImageView,
                                                   attribute: .right,
                                                   relatedBy: .equal,
                                                   toItem: imageView,
                                                   attribute: .right,
                                                   multiplier: 1.0,
                                                   constant: 0))
        
        imageView.addConstraint(NSLayoutConstraint(item: gifImageView,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: imageView,
                                                   attribute: .bottom,
                                                   multiplier: 1.0,
                                                   constant: 0))
    }
}














