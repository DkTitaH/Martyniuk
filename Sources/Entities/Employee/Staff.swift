//
//  State.swift
//  CarWash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Staff: Statable  {
    
    enum State {
        case busy
        case waitingForProcessing
        case available
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            guard self.atomicState.value != newValue else { return }
            self.atomicState.value = newValue
            self.observers.notify(state: newValue)
        }
    }
    
    let observers = ObserverCollection()
    let atomicState = Atomic(State.available)
    
    func observer(handler: @escaping Observer.Handler) {
        let observer = Observer(sender: self, handler: handler)
        self.observers.append(observer: observer)
    }
}
