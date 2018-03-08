//
//  YLTInputViewConfig.swift
//  YLTInputVIewDemo
//
//  Created by wangwenjie on 2018/3/5.
//  Copyright © 2018年 Roo. All rights reserved.
//

import Foundation

import RxSwift

struct YLTInputViewConfig {
    
    /// 扩展功能
    enum YLTInputExtendedType {
        case shoot
        case photo
        case experssion
        case audio
        case emoticon
        case file
        case patient
        case none
    }
    
    /// inputView高度
    let inputViewHeight = Variable<CGFloat>(92)
    /// toolbar 高度
    let toolbarHeight = Variable<CGFloat>(92)
    
    
    let inputViewExtendedList:Array<YLTInputExtendedType> = [.shoot,
                                                             .photo,
                                                             .experssion,
                                                             .audio,
                                                             .emoticon,
                                                             .file,
                                                             .patient]
    
}
