//
//  ObservableObject.swift
//  CarWash
//
//  Created by Student on 14.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class ObservableObject<State> {
    
    typealias Handler = (State) -> ()
    
    private let observers = Observers()
    
    public func observer(handler: @escaping Handler) -> Observer {
        let observer = Observer(sender: self, handler: handler)
        self.observers.append(observer: observer)
        
        return observer
    }
    
    func notify(_ state: State) {
        self.observers.notify(state: state)
    }
}
