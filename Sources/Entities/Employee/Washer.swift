//
//  Washer.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Washer: Employee<Car> {
    
    override func performProcessing(object: Car) {
        object.state.value = .clean
    }

    override func completeProcessing(object: Car) {
        self.receiveMoney(from: object)
    }

    override func finishWork() {
        print("\(self.name) washed car, and receive money: \(self.money)")
        self.state = .waitingForProcessing
    }
}
