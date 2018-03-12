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
        let tev = UITextView(frame: CGRect(x: 16, y: 5, width: SCREEN_WIDTH - 32, height: 37))
        tev.layer.cornerRadius = 4
        tev.layer.masksToBounds = true
        tev.returnKeyType = .send
        tev.delegate = self
        tev.font = UIFont(name: "PingFangSC-Regular", size: 16.0)
        self.addSubview(tev)
        
        inputTextView = tev

        
        let list = config.inputViewExtendedList
        for i in 0..<list.count {
            let btn:UIButton = self.createButton(list[i])
            btn.tag = i + increment
            btn.rx.tap.subscribe(onNext: { [weak self] in
                btn.isSelected = !btn.isSelected
                self?.setBtnSelected(btn.isSelected, btn.tag)
                self?.delegete?.onPressInputExtendedItem(list[i])
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
        
       textViewFrameChange(textView)
        
        if text == "\n" {
            actionDelegate?.onSendText(textView.text)
            textView.text = ""
            textViewFrameChange(textView)
            return false
        }else {
            return true
        }
    }
    
    func textViewFrameChange(_ textView: UITextView) {
        let w = SCREEN_WIDTH - 32
        let t_h = textView.text.heightWithConstrainedWidth(width: w, font: textView.font!)
        let tev_h = max(t_h, 37)
        config.toolbarHeight.value = tev_h + 55
        
        inputTextView.frame = CGRect(x: 16, y: 5, width: SCREEN_WIDTH - 32, height: tev_h)
    }
}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height + 5
    }
    
}
