//
//  Optional+Extension.swift
//  CarWash
//
//  Created by Student on 26.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension Optional {
    
    func `do`(_ action: (Wrapped) -> ()) {
        self.map(action)
    }
    
    func apply<Result>(_ transform: ((Wrapped) -> Result)?) -> Result? {
        return self.flatMap {
            transform?($0)
        }
    }
}
