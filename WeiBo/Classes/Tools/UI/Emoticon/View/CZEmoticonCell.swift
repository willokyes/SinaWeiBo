//
//  CZEmoticonCell.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/23.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

///
protocol CZEmoticonCellDelegate: NSObjectProtocol {
    //
    func emoticonCell(_ cell: CZEmoticonCell, didSelectAt emoticon: CZEmoticon?)
}

///
class CZEmoticonCell: UICollectionViewCell {
    //
    weak var delegate: CZEmoticonCellDelegate?
    
    //
    var emoticons: [CZEmoticon]? {
        didSet {
            Print(self, "表情数：\(emoticons?.count ?? 0)")
            
            //
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            contentView.subviews.last?.isHidden = false
            
            //
            for (i, em) in (emoticons ?? []).enumerated() {
                //
                if let btn = contentView.subviews[i] as? UIButton {
                    //
                    btn.setImage(em.image, for: .normal)
                    
                    //
                    btn.setTitle(em.emoji, for: .normal)
                    
                    //
                    btn.isHidden = false
                }
            }
        }
    }
    
    private lazy var tipView = CZEmoticonTipView()
    
    //    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    override func willMove(toWindow newWindow: UIWindow?) {
        //
        guard let w = newWindow else { return }
        
        w.addSubview(tipView)
        tipView.isHidden = true
    }
    
    //
    @objc func selectedEmoticonButton(button: UIButton) {
        //
        let tag = button.tag
        
        var em: CZEmoticon?
        if tag < (emoticons?.count)! {
            em = emoticons?[tag]
        }
        
        //
        delegate?.emoticonCell(self, didSelectAt: em)
    }
    
    //
    @objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        //
        let location = gestureRecognizer.location(in: self)
        
        guard let button = buttonWithLocation(location: location) else {
            tipView.isHidden = true
            return
        }
        
        //
        switch gestureRecognizer.state {
        case .began, .changed:
            tipView.isHidden = false
            let pt = CGPoint(x: button.center.x,
                             y: button.frame.origin.y + (button.imageView?.frame.origin.y ?? 0))
            tipView.center = convert(pt, to: window)
            tipView.emoticon = emoticons?[button.tag]
            Print(self, ".began, .changed")
        case .ended:
            tipView.isHidden = true
            selectedEmoticonButton(button: button)
            Print(self, ".ended")
        case .cancelled, .failed:
            tipView.isHidden = true
            Print(self, ".cancelled, .failed")
        default:
            break
        }
    }
    
    private func buttonWithLocation(location: CGPoint) -> UIButton? {
        //
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return btn
            }
        }
        
        return nil
    }
}

extension CZEmoticonCell {
    //
    func setupUI() {
        //
        let rowCount = 3
        let colCount = 7
        
        let leftMargin = 8
        let bottomMargin = 16

        let w = (Int(bounds.width) - leftMargin * 2) / (colCount)
        let h = (Int(bounds.height) - bottomMargin) / (rowCount)
        
        for i in 0..<21 {
            //
            let row = i / colCount
            let col = i % colCount
            
            let x = leftMargin + col * w
            let y = row * h
            
            //
            let btn = UIButton()
            
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            btn.tag = i
            
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
            
            contentView.addSubview(btn)
            
            //btn.backgroundColor = UIColor.cz_random()
        }
        
        //
        let image = UIImage(named: "compose_emotion_delete_highlighted",
                            in: CZEmoticonManager.shared.bundle,
                            compatibleWith: nil)
        let removeBtn = contentView.subviews.last as! UIButton
        removeBtn.setImage(image, for: .normal)
        
        //
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGesture)
    }
}












