//
//  WBStatusViewModel.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/14.
//  Copyright © 2018年 八月夏木. All rights reserved.
//: CustomStringConvertible

import Foundation

class WBStatusViewModel {
    //
    var status: WBStatus
    
    //
    var memberIcon: UIImage?
    
    //
    var vipIcon: UIImage?
    
    // for toolbar show
    var retweetedStr: String?
    var commentStr: String?
    var likeStr: String?
    
    //
    var pictureViewSize = CGSize()
    
    var picURLs: [WBStatusPicture]? {
        //
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    //
    var statusAttrText: NSAttributedString?
    
    //
    var retweetedAttrText: NSAttributedString?
    
    //
    var rowHeight: CGFloat = 0
    
    //
    init(model: WBStatus) {
        //
        status = model
        
        //
//        let pic_urls = status.retweeted_status?.pic_urls ?? status.pic_urls
//
//        for url in pic_urls ?? [] {
//            url.thumbnail_pic = url.thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "woriginal")
//        }
        
        //
        let memImageName: String?
        if let mbrank = model.user?.mbrank {
            if mbrank > 0 && mbrank < 7 {
                memImageName = "common_icon_membership_level\(mbrank)"
            } else {
                memImageName = "common_icon_membership"
            }
        } else {
            memImageName = "common_icon_membership"
        }
        
        memberIcon = UIImage(named: memImageName!)
        
        //
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
            break
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
            break
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
            break
        default:
            break
        }
        
        //
        retweetedStr = countString(count: status.reposts_count, defaultStr: "转发")
        commentStr = countString(count: status.comments_count, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count, defaultStr: "赞")
        
        //
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        //
        let originalFont = UIFont.systemFont(ofSize: 15)
        let statusText = model.text ?? ""
        statusAttrText = CZEmoticonManager.shared.imageTextString(string: statusText,
                                                                  font: originalFont)

        //
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        let retweetedText = "@\(status.retweeted_status?.user?.screen_name ?? "")：\(status.retweeted_status?.text ?? "")"
        retweetedAttrText = CZEmoticonManager.shared.imageTextString(string: retweetedText,
                                                                     font: retweetedFont)
                
        //
        updateRowHeight()
    }
    
    private func updateRowHeight() {
        //
        // 1、原创微博 Cell：顶部分隔条高度（12）+ 间距（12）+ 头像高度（34）+ 间距（12）+ 正文高度（）
        //    + 配图视图高度（）+ 间距（12）+ 底部工具栏高度（35）
        
        // 2、转发微博 Cell：顶部分隔条高度（12）+ 间距（12）+ 头像高度（34）+ 间距（12）+ 正文高度（）
        //    +  间距（12）+  间距（12）+ 转文高度（）
        //    + 配图视图高度（）+ 间距（12）+ 底部工具栏高度（35）
        
        //
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        //
        var height: CGFloat = 0
        
        //
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - margin * 2, height: CGFloat(MAXFLOAT))
        
        //
        height = margin + margin + iconHeight + margin
        
        if let text = statusAttrText {
            //
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        if status.retweeted_status != nil {
            //
            height += margin + margin
            
            //
            if let text = retweetedAttrText {
                //
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        //
        height += pictureViewSize.height
        height += margin
        height += toolbarHeight
        
        //
        rowHeight = height
    }
    
    
    private func calcPictureViewSize(count: Int?) -> CGSize {
        //
        guard let count = count else { return CGSize() }
        
        if count == 0 {
            return CGSize()
        }
        
        //
        let rows = CGFloat((count - 1) / 3 + 1)
        let height = WBStatusPictureViewOutterMargin +
            WBStatusPictureViewItemWidth * rows +
            WBStatusPictureViewInnerMargin * (rows - 1)
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    func updatePictureViewSizeOfSingleImage(image: UIImage) {
        //
        var size = image.size
        
        //
        let maxWidth: CGFloat = 300
        if size.width > maxWidth {
            size.width = maxWidth
            size.height = (image.size.height / image.size.width) * size.width
        }
        
        //
        let minWidth: CGFloat = 40
        if size.width < minWidth {
            size.width = minWidth
            size.height = (image.size.height / image.size.width) * size.width / 3
        }
        
        //
        size.height += WBStatusPictureViewOutterMargin
        
        pictureViewSize = size
        
        //
        updateRowHeight()
    }
    
    var description: String {
        return status.description
    }
    
    private func countString(count: Int, defaultStr: String) -> String {
        //
        if count == 0 {
            return defaultStr
        }
        
        //
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.2f 万", Double(count)/10000)
    }
    
}













