//
//  YLTInputProtocol.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import Foundation

import UIKit

import Photos

protocol YLTInputActionDelegate:class {
    
    /// 照相
    func onShoot()
    
    /// 文本消息
    func onSendText(_ text: String)
    
    /// 图片消息
    func onSendImage(_ imageList: Array<UIImage>)
    
    /// 展示大图
    func showPhotoDetail(_ fetchResult:PHFetchResult<PHAsset>?, _ selectedIndex: Int)
    ///
    func onStartRecording()
    
    func onStopRecording()
    
    func onCancelRecording()
    
    /// 文件
    func onSendFile()
    
    /// 共享患者
    func onSharePatient()
    
    /// 编辑常用语
    func onEditUsefulExpressions()
    
    
}
