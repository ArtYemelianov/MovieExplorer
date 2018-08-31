//
//  Resource.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation

struct Resource : CustomStringConvertible {
    let status: Bool?
    let list: [Genre]?
    let message: String?
    
    var description: String {
        let st = status?.description ?? "nil"
        let ls  = list?.description ?? "nil"
        let msg = message ?? "nil"
        return "isLoading \(st), list \(ls), msg \(msg)"
    }
}
