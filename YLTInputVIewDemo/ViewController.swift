//
//  ViewController.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/2.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class ViewController: UIViewController {

    let disposebag = DisposeBag()
    var sessionInputView: YLTInputView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionInputView = YLTInputView(frame:.zero)
        sessionInputView.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let h = sessionInputView.config.inputViewHeight.value
        sessionInputView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - h, width: SCREEN_WIDTH, height: h)
        sessionInputView.actionDelegate = self
        self.view.addSubview(sessionInputView)
        

        
        sessionInputView.config.inputViewHeight.asDriver().drive(onNext: { [weak self] (h) in
            UIView.animate(withDuration: 0.25, animations: {
                self?.sessionInputView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - h, width: SCREEN_WIDTH, height: h)
            })
        }).disposed(by: disposebag)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        sessionInputView.config.inputViewHeight.value = sessionInputView.config.toolbarHeight.value
        sessionInputView.resetInputView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: YLTInputActionDelegate {
    /// 照相
    func onShoot() {
        print("照相")
    }
    /// 文本消息
    func onSendText(_ text: String) {
        print(text)
    }
    /// 图片消息
    func onSendImage(_ imageList: Array<UIImage>) {
        print(imageList.first)
    }
    
    /// 展示大图
    func showPhotoDetail(_ fetchResult:PHFetchResult<PHAsset>?, _ selectedIndex: Int) {
        print("展示大图")
    }
    
    func onStartRecording() {
        
    }
    
    func onStopRecording(){
        
    }
    
    func onCancelRecording() {
        
    }
    
    /// 文件
    func onSendFile(){
        print("文件传输")
    }
    
    /// 共享患者
    func onSharePatient(){
        print("共享患者")
    }
    /// 编辑常用语
    func onEditUsefulExpressions() {
        sessionInputView.resetInputView()
        print("编辑常用语")
    }
}

