//
//  Cancellable.swift
//  CarWash
//
//  Created by Student on 24.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Cancellable {
    
    var isCancelled: Bool { get }
    
    func cancel()
}
