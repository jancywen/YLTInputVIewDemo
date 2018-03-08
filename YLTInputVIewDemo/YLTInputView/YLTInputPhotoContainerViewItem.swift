//
//  YLTInputPhotoContainerViewItem.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/5.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
protocol YLTInputPhotoContainerViewItemDelegate:class {
    func didSelectedItem(_ index: Int)
}

class YLTInputPhotoContainerViewItem: UICollectionViewCell {

    
    fileprivate var imageView: UIImageView!
    fileprivate var btnSelect: UIButton!
    
    let disposeBag = DisposeBag()
    
    weak var delegate: YLTInputPhotoContainerViewItemDelegate?
    
    var index:Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configView() {
        imageView = UIImageView(frame:.zero)
        imageView.backgroundColor = .brown
        imageView.tag = 1
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        let btn = UIButton(frame: .zero)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.didSelectedItem((self?.index)!)
        }).disposed(by: disposeBag)
        
        btn.layer.cornerRadius = 12
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        
        self.contentView.addSubview(btn)
        
        btn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        btnSelect = btn
    }
    
    func updateSelectBtnTitle(_ title: Int?) {
        btnSelect.backgroundColor = title != nil ? UIColor(red: 51.0/255.0, green: 96/255, blue: 230/255, alpha: 1.0) : .clear
        btnSelect.setTitle(title != nil ? String(title! + 1) : nil, for: .normal)
    }
    
}
