//
//  YLTInputExpressionsContainerViewCell.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class YLTInputExpressionsContainerViewCell: UITableViewCell {

    var labExp: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell() {
        
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        
        let bg = UIView(frame: .zero)
        bg.backgroundColor = UIColor(red: 177/255, green: 182/255, blue: 216/255, alpha: 1.0)
        bg.layer.cornerRadius = 8
        bg.layer.masksToBounds = true
        self.contentView.addSubview(bg)
        
        let exp = UILabel(frame: .zero)
        exp.textColor = .white
        exp.font = UIFont(name: "PingFangSC-Regular", size: 14)
        exp.numberOfLines = 0
        self.contentView.addSubview(exp)
        exp.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-22)
            make.top.equalToSuperview().offset(7)
        }
        
        bg.snp.makeConstraints { (make) in
            make.top.equalTo(exp.snp.top).offset(-7)
            make.left.equalTo(exp.snp.left).offset(-10)
            make.right.equalTo(exp.snp.right).offset(10)
            make.bottom.equalTo(exp.snp.bottom).offset(7)
        }
        labExp = exp
    }
    
    
}
