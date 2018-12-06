//
//  NSLock+Extension.swift
//  CarWash
//
//  Created by Student on 30.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension NSLocking {
    
    func locked<Result> (_ action: () -> Result) -> Result{
        self.lock()
        defer { self.unlock() }
        
        return action()
    }
}
