//
//  ObservableObject.Observer.swift
//  CarWash
//
//  Created by Student on 19.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observer: Hashable {
        
        var hashValue: Int {
            return ObjectIdentifier(self).hashValue
        }
        
        var isObserving: Bool {
            return self.sender != nil
        }
        
        let handler: Handler
        
        private weak var sender: ObservableObject?
        
        init(sender: ObservableObject, handler: @escaping Handler) {
            self.handler = handler
            self.sender = sender
        }
        
        func stop() {
            self.sender = nil
        }
        
        static func == (lhs: ObservableObject<State>.Observer, rhs: ObservableObject<State>.Observer) -> Bool {
            return lhs === rhs
        }
    }
}
