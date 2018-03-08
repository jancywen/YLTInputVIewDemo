//
//  YLTInputToolBar.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/2.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

import SnapKit

import RxCocoa
import RxSwift

protocol YLTInputToolBarDelegate:class {
    func onPressInputExtendedItem(_ item: YLTInputViewConfig.YLTInputExtendedType)
}

class YLTInputToolBar: UIView {

   let increment = 1000
   
    var inputTextView: UITextView!
    
    weak var actionDelegate: YLTInputActionDelegate?

    weak var delegete: YLTInputToolBarDelegate?
    
    let disposeBag = DisposeBag()

    var config: YLTInputViewConfig!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInputToolBar()
    }
    
    init(config: YLTInputViewConfig) {
        super.init(frame: .zero)
        self.config = config
        configInputToolBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configInputToolBar() {
        let tev = UITextView(frame: CGRect.zero)
        tev.layer.cornerRadius = 4
        tev.layer.masksToBounds = true
        tev.returnKeyType = .send
        tev.delegate = self
        self.addSubview(tev)
        tev.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(37)
        }
        inputTextView = tev

        
        let list = config.inputViewExtendedList
        for i in 0..<list.count {
            let btn:UIButton = self.createButton(list[i])
            btn.tag = i + increment
            btn.rx.tap.subscribe(onNext: { [weak self] in
                self?.delegete?.onPressInputExtendedItem(list[i])
                btn.isSelected = !btn.isSelected
                self?.setBtnSelected(btn.isSelected, btn.tag)
            }).disposed(by: disposeBag)
            self.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(16 + i * 45)
                make.bottom.equalToSuperview().offset(-15)
                make.size.equalTo(CGSize(width:26, height: 20))
            })
        }
        
    }
    
    func setBtnSelected(_ selected: Bool, _ tag: Int) {
        for sub in self.subviews {
            if sub.isKind(of: UIButton.self) {
                let btn = sub as! UIButton
                if sub.tag == tag {
                    btn.isSelected = selected
                }else {
                    btn.isSelected = false
                }
            }
        }
    }
    
    func setInputConfig(_ inputViewConfig: YLTInputViewConfig) {
        
    }
    
    func createButton(_ type: YLTInputViewConfig.YLTInputExtendedType) -> UIButton {
        let btn = UIButton(frame: .zero)
        
        switch type {
        case .shoot:
            btn.setImage(#imageLiteral(resourceName: "icon_input_short_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_short_normal"), for: .selected)
        case .photo:
            btn.setImage(#imageLiteral(resourceName: "icon_input_photo_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_photo_pressed"), for: .selected)
        case .experssion:
            btn.setImage(#imageLiteral(resourceName: "icon_input_expression_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_expression_pressed"), for: .selected)
        case .emoticon:
            btn.setImage(#imageLiteral(resourceName: "icon_input_emoticon_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_emoticon_pressed"), for: .selected)
        case .audio:
            btn.setImage(#imageLiteral(resourceName: "icon_input_audio_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_audio_pressed"), for: .selected)
        case .file:
            btn.setImage(#imageLiteral(resourceName: "icon_input_file_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_file_normal"), for: .selected)
        case .patient:
            btn.setImage(#imageLiteral(resourceName: "icon_input_patient_normal"), for: .normal)
            btn.setImage(#imageLiteral(resourceName: "icon_input_patient_normal"), for: .selected)
        default:
            break
        }
        return btn
    }
    
}

extension YLTInputToolBar: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            actionDelegate?.onSendText(textView.text)
            textView.text = ""
            return false
        }else {
            return true
        }
    }
}
