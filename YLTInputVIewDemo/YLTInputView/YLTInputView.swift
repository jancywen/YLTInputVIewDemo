//
//  YLTInputView.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/2.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum YLTInputType {
    case text
    case photo
    case expression
    case audio
    case emoticon
    case file
    case patient
}

class YLTInputView: UIView {

    /// toolbar
    var toolbar: YLTInputToolBar!
    
    let config = YLTInputViewConfig()
    
    let disposeBag = DisposeBag()
    
    /// 记录是否是点击了toolbar上的按钮
    var btnTap = false
    
    /// 图片
    var photoContainerView: YLTInputPhotoContainerView!
    
    /// 常用语
    var expressionContainerView: YLTInputExpressionsContainerView!
    
    /// 语音输入
    var audioContainerView: YLTInputAudioContainerView!
    
    var inputType: YLTInputType = .text
    
    var inputExtendedItem: YLTInputViewConfig.YLTInputExtendedType = .none
    
    weak var actionDelegate: YLTInputActionDelegate? {
        didSet {
            toolbar.actionDelegate = actionDelegate
        }
    }
    
    
    /// 构造器
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInputView()
        addListenEvent()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addListenEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect            
            var bottomHeight:CGFloat = 0
            if endFrame.origin.y != SCREEN_HEIGHT {
                bottomHeight = endFrame.size.height
            }
            if btnTap {
                btnTap = false
            }else {
                self.changeFrame(bottomHeight)
            }
        }
    }
    
    
    
}


extension YLTInputView:YLTInputToolBarDelegate {
    fileprivate func configInputView() {
        
        let bar = YLTInputToolBar(config: self.config)
        bar.delegete = self
        self.addSubview(bar)
        
        config.toolbarHeight.asDriver().drive(onNext: { (h) in
            bar.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: h)
        }).disposed(by: disposeBag)
        
        
        toolbar = bar
    }
    
    func onPressInputExtendedItem(_ item: YLTInputViewConfig.YLTInputExtendedType) {
        if inputExtendedItem == item {
            resetInputView()
            return
        }
        
        inputExtendedItem = item
        
        switch item {
        case .shoot:
            tapChangeFrame(0)
            inputExtendedItem = .none
            actionDelegate?.onShoot()
            break
        case .photo:
            tapChangeFrame(YLTInputViewBottomHeight)
            showPhotos()
            break
        case .experssion:
            tapChangeFrame(YLTInputViewBottomHeight)
            showExpressions()
            break
        case .emoticon:
            tapChangeFrame(0)
            break
        case .audio:
            tapChangeFrame(YLTInputViewBottomHeight)
            showAudio()
            break
        case .file:
            tapChangeFrame(0)
            inputExtendedItem = .none
            actionDelegate?.onSendFile()
            break
        case .patient:
            tapChangeFrame(0)
            inputExtendedItem = .none
            actionDelegate?.onSharePatient()
            break
        default:
            break
        }
        
        
    }
    
    fileprivate func tapChangeFrame(_ bottomHeight: CGFloat) {
        btnTap = true
        toolbar.inputTextView.resignFirstResponder()
        changeFrame(bottomHeight)
        btnTap = false
    }
    
    fileprivate func changeFrame(_ bottomHeight:CGFloat) {
        config.inputViewHeight.value = config.toolbarHeight.value + bottomHeight
    }
    
    fileprivate func showPhotos() {
        if photoContainerView == nil {
            photoContainerView = YLTInputPhotoContainerView(frame: .zero)
            photoContainerView.frame = CGRect(x: 0, y: config.toolbarHeight.value, width: SCREEN_WIDTH, height: YLTInputViewBottomHeight)
            photoContainerView.actionDelegate = actionDelegate
            self.addSubview(photoContainerView)
        }else {
            photoContainerView.isHidden = false
            photoContainerView.updatePhoto()
        }
        
        expressionContainerView?.isHidden = true
        audioContainerView?.isHidden = true
    }
    
    fileprivate func showExpressions() {
        if expressionContainerView == nil {
            expressionContainerView = YLTInputExpressionsContainerView(frame: .zero)
            expressionContainerView.frame = CGRect(x: 0, y: config.toolbarHeight.value, width: SCREEN_WIDTH, height: YLTInputViewBottomHeight)
            expressionContainerView.actionDelegate = actionDelegate
            self.addSubview(expressionContainerView)
        }else {
            expressionContainerView.isHidden = false
        }
        
        photoContainerView?.isHidden = true
        audioContainerView?.isHidden = true
    }
    
    fileprivate func showAudio() {
        if audioContainerView == nil {
            audioContainerView = YLTInputAudioContainerView(frame: .zero)
            audioContainerView.frame = CGRect(x: 0, y: config.toolbarHeight.value, width: SCREEN_WIDTH, height: YLTInputViewBottomHeight)
            audioContainerView.actionDelegate = actionDelegate
            self.addSubview(audioContainerView)
        }else {
            audioContainerView.isHidden = false
        }
        
        photoContainerView?.isHidden = true
        expressionContainerView?.isHidden = true
    }
    
    func setInputType(_ type: YLTInputType) {
        
    }
    
}
// MARK: 外置方法
extension YLTInputView {
    func updateAudioRecordTime(_ time: TimeInterval) {
        audioContainerView?.recordTime = time
    }
    
    func resetInputView() {
        tapChangeFrame(0)
        inputExtendedItem = .none
        photoContainerView?.isHidden = true
        expressionContainerView?.isHidden = true
        audioContainerView?.isHidden = true
    }
}
