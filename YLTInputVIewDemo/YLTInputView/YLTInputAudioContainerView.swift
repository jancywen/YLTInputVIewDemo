//
//  YLTInputAudioContainerView.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


enum YLTAudioRecordPhase {
    case start
    case recording
    case cancel
    case end
}

class YLTInputAudioContainerView: UIView, UIGestureRecognizerDelegate {

   
    var btnAudio:UIButton!
    
    var labTime: UILabel!
    
    var labMark: UILabel!
    
    
    var recordPhase: YLTAudioRecordPhase!
    
    var recordTime: TimeInterval! {
        didSet{
            let minutes = Int(recordTime) / 60
            let seconds = Int(recordTime) % 60
            labTime?.text = String(format: "%02zd:%02zd", minutes, seconds)
        }
    }
    
    weak var actionDelegate: YLTInputActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configView() {
        
        recordPhase = .end
        
        let timeCount = UILabel(frame:.zero)
        timeCount.text = "00:00"
        self.addSubview(timeCount)
        timeCount.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview() 
        }
        
        let mark = UILabel(frame: .zero)
        self.addSubview(mark)
        mark.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        
        let audio = UIButton(frame: .zero)
        audio.setImage(#imageLiteral(resourceName: "icon_input_audio_normal"), for: .normal)
        audio.layer.cornerRadius = 50
        audio.layer.masksToBounds = true
        audio.backgroundColor = UIColor(red: 51.0/255.0, green: 96/255, blue: 230/255, alpha: 1.0)
        audio.addTarget(self, action: #selector(btnAcdio_touchDown(_:)), for: .touchDown)
        audio.addTarget(self, action: #selector(btnAudio_touchDragInside(_:)), for: .touchDragInside)
        audio.addTarget(self, action: #selector(btnAudio_touchDragOutside(_:)), for: .touchDragOutside)
        audio.addTarget(self, action: #selector(btnAudio_touchUpInside(_:)), for: .touchUpInside)
        audio.addTarget(self, action: #selector(btnAudio_touchUpOutside(_:)), for: .touchUpOutside)
        self.addSubview(audio)
        audio.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        let del = UIButton(frame: .zero)
        del.setBackgroundImage(#imageLiteral(resourceName: "icon_input_audio_delete"), for: .normal)
        
        self.addSubview(del)
        del.snp.makeConstraints { (make) in
            make.left.equalTo(audio.snp.right).offset(65)
            make.bottom.equalTo(audio.snp.centerY).offset(-20)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        
        labMark = mark
        labTime = timeCount
        btnAudio = audio
    }

    @objc fileprivate func btnAcdio_touchDown(_ sender: UIButton) {
        setRecordPhase(.start)
    }
    @objc fileprivate func btnAudio_touchDragInside(_ sender: UIButton) {
        setRecordPhase(.recording)
    }
    @objc fileprivate func btnAudio_touchDragOutside(_ sender: UIButton) {
        setRecordPhase(.cancel)
    }
    @objc fileprivate func btnAudio_touchUpInside(_ sender: UIButton) {
        setRecordPhase(.end)
    }
    @objc fileprivate func btnAudio_touchUpOutside(_ sender: UIButton) {
        setRecordPhase(.end)
    }
    
    
    func setRecordPhase(_ phase: YLTAudioRecordPhase) {
        let prevPhase:YLTAudioRecordPhase = recordPhase
        recordPhase = phase
        self.setPhase(phase)
        
        switch prevPhase {
        case .end:
            if recordPhase == .start {
                actionDelegate?.onStartRecording()
            }
        case .start, .recording:
            if recordPhase == .end {
                actionDelegate?.onStopRecording()
            }
        default:
            if  recordPhase == .end {
                actionDelegate?.onCancelRecording()
            }
        }
        
    }
    
    func setPhase(_ phase: YLTAudioRecordPhase) {
        
        if phase == .start {
            recordTime = 0
        }else if phase == .cancel {
            labMark.text = "松开手指, 取消发送"
            
        }else {
            labMark.text = "左右滑动, 取消发送"
        }
        
        labMark.isHidden = phase != .cancel
        labTime.isHidden = phase == .cancel
    }
}

extension YLTInputAudioContainerView {
    
    
}

