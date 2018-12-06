//
//  Replaceble.swift
//  CarWash
//
//  Created by Student on 26.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    
    mutating func safelyRemoveFirst() -> Element? {
        return self.isEmpty ? nil : self.removeFirst()
    }
}
