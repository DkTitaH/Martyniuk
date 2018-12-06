//
//  Accountant.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Accountant: Manager<Washer> {
    
    override func finishWork() {
        super.finishWork()
        print("\(self.name) accountant have money: \(self.money)")
    }
}
