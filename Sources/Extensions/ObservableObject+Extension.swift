//
//  ObservableObject+Extension.swift
//  CarWash
//
//  Created by Student on 14.12.2018.
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

extension ObservableObject {
    
    class Observers {
        
        typealias Observer = ObservableObject.Observer
        
        private let observers = Atomic([Observer]())
        
        func append(observer: Observer) {
            self.observers.modify {
                $0.append(observer)
            }
        }
        
        func notify(state: State) {
            self.observers.modify {
                $0 = $0.filter { $0.isObserving }
                $0.forEach { observer in
                    DispatchQueue.background.async {
                        observer.handler(state)
                    }
                }
            }
        }
        
        static func += (lhs: Observers, rhs: [Observer]) {
            lhs.observers.modify { $0 += rhs }
        }
    }
}


