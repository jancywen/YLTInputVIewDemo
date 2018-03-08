//
//  YLTInputPhotoContainerView.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/2.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos


class YLTInputPhotoContainerView: UIView {

    
    fileprivate var covList: UICollectionView!
    
    let cellIdentifier = "cellIdentifier"
    
    let disposeBag = DisposeBag()
    
    var btnOriginal: UIButton!
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>?
    
    ///缩略图大小
    let assetGridThumbnailSize = CGSize(width: 117, height: 206)
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    /// 代理
    weak var actionDelegate: YLTInputActionDelegate? 
    
    /// 选中的索引
    lazy var indexList = [Int]()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cov = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cov.delegate = self
        cov.dataSource = self
        cov.register(YLTInputPhotoContainerViewItem.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        cov.backgroundColor = .clear
        cov.showsVerticalScrollIndicator = false
        cov.showsHorizontalScrollIndicator = false
        self.addSubview(cov)
        
        cov.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-44)
        }
        covList = cov
        
        let bottomBg = UIView(frame: .zero)
        bottomBg.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        self.addSubview(bottomBg)
        bottomBg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let original = UIButton(frame: .zero)
        
        original.layer.cornerRadius = 1
        original.layer.masksToBounds = true
        original.layer.borderWidth = 1
        original.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
        
        original.rx.tap.subscribe(onNext: {
            original.isSelected = !original.isSelected
            original.backgroundColor = original.isSelected ? UIColor(red: 51.0/255.0, green: 96/255, blue: 230/255, alpha: 1.0) : .clear
        }).disposed(by: disposeBag)
        bottomBg.addSubview(original)
        original.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        btnOriginal = original
        
        
        
        let lab = UILabel(frame: .zero)
        lab.text = "原图"
        lab.textColor = UIColor(red:51/255, green: 51/255, blue: 51/255 , alpha: 1.0)
        lab.font = UIFont(name: "PingFangSC-Regular", size: 14.0)
        bottomBg.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.left.equalTo((original.snp.right)).offset(5)
            make.centerY.equalTo(original.snp.centerY)
        }
        
        let sender = UIButton(frame: .zero)
        sender.setTitle("发送", for: .normal)
        sender.backgroundColor = UIColor(red: 51.0/255.0, green: 96/255, blue: 230/255, alpha: 1.0)
        sender.layer.cornerRadius = 4
        sender.layer.masksToBounds = true
        
        sender.rx.tap.subscribe(onNext: { [weak self] in
            self?.sendImage()
        }).disposed(by: disposeBag)
        
        bottomBg.addSubview(sender)
        sender.snp.makeConstraints { (make) in
            make.centerY.equalTo(original.snp.centerY)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 60, height: 26))
        }
        
        
        
        getPhoto()
    }

    /// 获取相册中的图片
    func getPhoto() {
        //申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            //则获取所有资源
            let allPhotosOptions = PHFetchOptions()
            //按照创建时间倒序排列
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                 ascending: false)]
            //只获取图片
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                     PHAssetMediaType.image.rawValue)
            self.assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                          options: allPhotosOptions)
            
            // 初始化和重置缓存
            self.imageManager = PHCachingImageManager()
            self.resetCachedAssets()
            
            //collection view 重新加载数据
            DispatchQueue.main.async{
                self.covList?.reloadData()
            }
        })
    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    /// sender image
    func sendImage() {
        
        if indexList.count == 0 {
            return
        }
        var tempList = [UIImage]()
        
        for i in indexList{
            if let asset = self.assetsFetchResults?[i] {
                //获取缩略图
                self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize ,
                                               contentMode: .aspectFill ,
                                               options: nil) { (image, nfo) in
                                                if image != nil {
                                                    tempList.append(image!)
                                                }
                }
//                self.imageManager.requestImage(for: asset, targetSize: btnOriginal.isSelected == false ? assetGridThumbnailSize : PHImageManagerMaximumSize,
//                                               contentMode: btnOriginal.isSelected == false ? .aspectFill : .default,
//                                               options: nil) { (image, nfo) in
//                                                if image != nil {
//                                                    tempList.append(image!)
//                                                }
//                }
            }
        }
        actionDelegate?.onSendImage(tempList)
        
        indexList.removeAll()
        covList.reloadData()
    }
}

extension YLTInputPhotoContainerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YLTInputPhotoContainerViewItemDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! YLTInputPhotoContainerViewItem

        cell.index = indexPath.row
        cell.delegate = self
        cell.updateSelectBtnTitle(indexList.index(of: indexPath.row))
        
        
        if let asset = self.assetsFetchResults?[indexPath.row] {
            //获取缩略图
            self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize,
                                           contentMode: PHImageContentMode.aspectFill,
                                           options: nil) { (image, nfo) in
                                            (cell.contentView.viewWithTag(1) as! UIImageView).image = image
            }
        }
        
        return cell
    }
    
    //返回单元格大小
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return assetGridThumbnailSize
    }
    
    //每个分组的内边距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    //单元格的行间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    //单元格横向的最小间距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        actionDelegate?.showPhotoDetail(self.assetsFetchResults, indexPath.row)
    }
    
    
    func didSelectedItem(_ index: Int) {
        if let itemIndex = indexList.index(of: index) {
            indexList.remove(at: itemIndex)
        }else {
            indexList.append(index)
        }
        covList.reloadData()
    }
 
}

// MARK: 外置方法
extension YLTInputPhotoContainerView {
    // 刷新图片
    func updatePhoto() {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            //则获取所有资源
            let allPhotosOptions = PHFetchOptions()
            //按照创建时间倒序排列
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                 ascending: false)]
            //只获取图片
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                     PHAssetMediaType.image.rawValue)
            self.assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                          options: allPhotosOptions)
            
            // 初始化和重置缓存
//            self.imageManager = PHCachingImageManager()
            self.resetCachedAssets()
            
            //collection view 重新加载数据
            DispatchQueue.main.async{
                self.covList?.reloadData()
            }
        })
    }
}

