//
//  State.swift
//  CarWash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Staff: ObservableObject<Staff.State>, Statable {
    
    enum State {
        case busy
        case waitingForProcessing
        case available
    }
    
    var state: State  {
        get { return self.atomicState.value }
        set { self.atomicState.value = newValue }
    }

    let atomicState = Atomic(State.available)
}
