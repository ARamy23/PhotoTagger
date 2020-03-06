//
//  Dynamic.swift
//  ForHer
//
//  Created by Ahmed Ramy on 3/5/20.
//  Copyright © 2020 Mohammed Elnaggar. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    typealias Listener = (T) -> ()
    var bind: Listener = { _ in }
    
    var value: T? {
        didSet {
            bind(value!)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
