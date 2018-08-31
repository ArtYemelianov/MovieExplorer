//
//  AppExecutors.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class AppExecutors{
    
    /** It is responsible for some background job  */
    private static var _background: SerialDispatchQueueScheduler?
    /** It is responsible for diskIO job  */
    private static var _diskIO: SerialDispatchQueueScheduler?
    
    private init(){
        // do nothing
    }
    
    class var background: SerialDispatchQueueScheduler{
        if _background == nil {
            _background = SerialDispatchQueueScheduler(internalSerialQueueName: "background_job")
        }
        return _background!
    }
    
    class var diskIO: SerialDispatchQueueScheduler{
        if _diskIO == nil {
            _diskIO = SerialDispatchQueueScheduler(internalSerialQueueName: "diskIO_job")
        }
        return _diskIO!
    }
    
    class var main: SerialDispatchQueueScheduler {
        return MainScheduler.instance
    }
}
