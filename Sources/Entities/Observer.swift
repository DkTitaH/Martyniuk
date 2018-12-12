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
    
    let handler: Handler
    
    private weak var sender: Staff?
    
    init(sender: Staff, handler: @escaping Handler) {
        self.handler = handler
        self.sender = sender
    }
    
    func stop() {
        self.sender = nil
    }
}
