//
//  Car.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Car: MoneyGiver {
    
    enum CarState {
        case dirty
        case clean
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    let state = Atomic<CarState>(.dirty)
    let name: String
    
    private let atomicMoney = Atomic(0)
    
    init(name: String, money: Int) {
        self.name = name
        self.atomicMoney.value = money
    }
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }

            return money
        }
    }
}
