//
//  Observer.swift
//  CarWash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Observer {
    
    typealias Handler = (Staff.State) -> ()
    
    var isObserving: Bool {
        return self.sender != nil
    }
    
    weak var sender: Staff?
    let handler: Handler
    
    init(sender: Staff, handler: @escaping Handler) {
        self.handler = handler
        self.sender = sender
    }
}
