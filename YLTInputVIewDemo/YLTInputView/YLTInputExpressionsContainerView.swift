//
//  YLTInputExpressionsContainerView.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class YLTInputExpressionsContainerView: UIView {

    
    let cellIdentifier = "cellIdentifier"
    
    var tavList: UITableView!
    
    var sourceDataList = Variable(["我是常用语我是常用语我是常用语",
                                   "我是常用语我是常用语我是常用语我是常用语我是常用语我是常用语我是常用语",
                                   "我是常用语我是常用语我是常用语我是常用语我是常用语",
                                   "是的,我是常用语"])
    
    let disposeBag = DisposeBag()
    
    weak var actionDelegate: YLTInputActionDelegate? 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        
        
        
        let tav = UITableView(frame: .zero, style: .plain)
//        tav.delegate = self
//        tav.dataSource = self
        tav.register(YLTInputExpressionsContainerViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        
        tav.estimatedRowHeight = 20
        tav.rowHeight = UITableViewAutomaticDimension
        
        tav.separatorStyle = .none
        
        tav.backgroundColor = .clear
        
//        sourceDataList.asObservable().bind(to: tav.rx.items) { [weak self](tableView, row, element) in
//            let cell = tableView.dequeueReusableCell(withIdentifier: (self?.cellIdentifier)!)! as! YLTInputExpressionsContainerViewCell
//            cell.labExp.text = element
//            return cell
//            }.disposed(by: disposeBag)
        
        //获取选中项的内容
        tav.rx.modelSelected(String.self).subscribe(onNext: { [weak self] item in
            self?.actionDelegate?.onSendText(item)
        }).disposed(by: disposeBag)

        sourceDataList.asDriver().drive(tav.rx.items(cellIdentifier: cellIdentifier)) { (_, element, cell) in
            let expCell = cell as! YLTInputExpressionsContainerViewCell
            expCell.labExp.text = element
        }.disposed(by: disposeBag)
        
//        sourceDataList.asDriver().drive(tav.rx.items) { [weak self](tableView, row, element) in
//            let cell = tableView.dequeueReusableCell(withIdentifier: (self?.cellIdentifier)!)! as! YLTInputExpressionsContainerViewCell
//            cell.labExp.text = element
//            return cell
//            }.disposed(by: disposeBag)
        
        self.addSubview(tav)
        tav.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(YLTInputViewBottomHeight - 44)
        }
        tavList = tav
        
        let bottomBg = UIView(frame: .zero)
        bottomBg.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        self.addSubview(bottomBg)
        bottomBg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let btn = UIButton(frame:.zero)
        btn.setTitle("编辑常用语", for: .normal)
        btn.setTitleColor(UIColor(red: 55/255, green: 100/255, blue: 227/255, alpha: 1.0), for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 16)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.actionDelegate?.onEditUsefulExpressions()
        }).disposed(by: disposeBag)
        bottomBg.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }

}

// MARK: - 外置方法
extension YLTInputExpressionsContainerView {
    /// 刷新常用语
    func updateExpression(_ list: Array<String>) {
        self.sourceDataList.value = list
    }
}
