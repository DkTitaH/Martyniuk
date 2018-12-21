//
//  ObservableObject+Extension.swift
//  CarWash
//
//  Created by Student on 14.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observers {
        
        typealias Observer = ObservableObject.Observer
        
        private let observers = Atomic([Observer]())
        
        init() {

        }
        
        convenience init(observersArray: [Observer]) {
            self.init()
            let observersArray = Atomic(observersArray)
            self.observers.modify { $0 = observersArray.value }
        }
        
        func append(observer: Observer) {
            self.observers.modify {
                $0.append(observer)
            }
        }
        
        func notify(state: State) {
            self.observers.modify {
                $0 = $0.filter { $0.isObserving }
                $0.forEach { observer in
                    observer.handler(state)
                }
            }
        }
        
        static func += (lhs: Observers, rhs: Observers) {
            lhs.observers.modify {
                $0 += rhs.observers.value
            }
        }
    }
}
