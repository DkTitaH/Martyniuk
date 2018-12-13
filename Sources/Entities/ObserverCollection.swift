//
//  ObserverCollection.swift
//  CarWash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class ObserverCollection {
    
    private let observers = Atomic([Observer]())
    
    func append(observer: Observer) {
        self.observers.modify {
            $0.append(observer)
        }
    }
    
    func notify(state: Staff.State) {
        self.observers.modify {
            $0 = $0.filter { $0.isObserving }
            $0.forEach {
                $0.handler(state)
            }
        }
    }
}
