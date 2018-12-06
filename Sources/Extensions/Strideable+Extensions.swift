//
//  Int+Extension.swift
//  CarWash
//
//  Created by Student on 26.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension Strideable where Self.Stride: SignedInteger, Self: ExpressibleByIntegerLiteral {
    
    func times(_ execute: () -> ()) {
        (0..<self).forEach {_ in
            execute()
        }
    }
}
