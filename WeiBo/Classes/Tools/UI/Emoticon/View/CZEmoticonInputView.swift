//
//  CZEmoticonInputView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/22.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class CZEmoticonInputView: UIView {
    //
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: CZEmoticonToolbar!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //
    private var selectEmoticonCallBack: ((CZEmoticon?)->())?
    
    //
    class func inputView(selectEmoticonCompletion: @escaping (CZEmoticon?)->()) -> CZEmoticonInputView {
        //
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! CZEmoticonInputView
        
        v.selectEmoticonCallBack = selectEmoticonCompletion

        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
        //let nib = UINib(nibName: "CZEmoticonCell", bundle: nil)
        //collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        
        //
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        //
        toolbar.delegate = self
        
        //
        let bundle = CZEmoticonManager.shared.bundle
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil)
        else { return }
        
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedImage, forKey: "_currentPageImage")
    }
}

///
extension CZEmoticonInputView: UICollectionViewDelegate {
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        Print(self, scrollView.contentOffset)
        
        //
        let hitPoint = CGPoint(x: scrollView.contentOffset.x + scrollView.center.x,
                               y: scrollView.center.y)
        
        //
        var nextIndexPath: IndexPath?
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.frame.contains(hitPoint) == true {
                nextIndexPath = indexPath
                break
            }
        }
        
        if let nextIndexPath = nextIndexPath {
            //
            toolbar.selectedIndex = nextIndexPath.section
            
            //
            pageControl.numberOfPages = collectionView.numberOfItems(inSection: nextIndexPath.section)
            pageControl.currentPage = nextIndexPath.item
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //
        
    }
}

///
extension CZEmoticonInputView: UICollectionViewDataSource {
    //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //
        return CZEmoticonManager.shared.packages.count
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return CZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CZEmoticonCell
        
        //
        cell.delegate = self
        
        //
        cell.emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticonsOfPage(indexPath.item)
        
        //
        return cell
    }
}

///
extension CZEmoticonInputView: CZEmoticonCellDelegate {
    //
    func emoticonCell(_ cell: CZEmoticonCell, didSelectAt emoticon: CZEmoticon?) {
        //
        selectEmoticonCallBack?(emoticon)
        
        //
        guard let em = emoticon else { return }
        
        //
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        //
        CZEmoticonManager.shared.recentEmoticon(em: em)
        
        //
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}

///
extension CZEmoticonInputView: CZEmoticonToolbarDelegate {
    //
    func emoticonToolbar(_ toolbar: CZEmoticonToolbar, didSelectItemAt index: Int) {
        //
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        //
        toolbar.selectedIndex = index
    }
}









