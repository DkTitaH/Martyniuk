//
//  Director.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Director: Manager<Accountant> {
    
    override func finishWork() {
        self.atomicState.value = .available
        print("\(self.name) director have money: \(self.money)")
    }
}
