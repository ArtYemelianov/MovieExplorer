//
//  Resource.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

struct Resource<Element> : CustomStringConvertible {
    public typealias E = Element
    let status: Bool?
    let data: E?
    let message: String?
    
    var description: String {
        let st = status?.description ?? "nil"
        let ls  = String(describing: data)
        let msg = message ?? "nil"
        return "isLoading \(st), list \(ls), msg \(msg)"
    }
    
}

extension Resource {
    static var loading : Resource {
        get {
            return Resource(status: true, data: nil, message: nil)
        }
    }
    
    static func storage<T>(data : T) -> Resource<T> {
        return Resource<T>(status: true, data: data, message: nil)
    }
    
    static func success<T>(data : T) -> Resource<T> {
        return Resource<T>(status: false, data: data, message: nil)
    }
    
    static func error<T>(msg :String) -> Resource<T> {
        return Resource<T>(status: true, data: nil, message: msg)
    }
}
