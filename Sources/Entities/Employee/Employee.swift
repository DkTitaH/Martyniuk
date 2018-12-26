//
//  Staff.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Employee<ProcessingObject: MoneyGiver>: Staff, MoneyReceiver, MoneyGiver {
    
    override var state: Staff.State {
        get { return self.atomicState.value }
        set {
            self.atomicState.modify { state in
                state = newValue
                self.notify(newValue)
            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    let name: String
    
    private let queue: DispatchQueue
    private let durationRange = 0.1...1.0
    
    private let atomicMoney = Atomic(0)
    
    init(name: String, queue: DispatchQueue = .background) {
        self.name = name
        self.queue = queue
    }
    
    func receive(money: Int ) {
        self.atomicMoney.modify {
            $0 += money
        }
    }
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
    
    func performProcessing(object: ProcessingObject) {
        self.receiveMoney(from: object)
    }
    
    func completeProcessing(object: ProcessingObject) {
        
    }

    func finishWork() {
        self.state = .waitingForProcessing
    }

    func asyncProcess(object: ProcessingObject) {
//        self.atomicState.modify {
//            if $0 == .available {
//                $0 = .busy
                self.state = .busy
                self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationRange)) {
                    self.performProcessing(object: object)
                    self.completeProcessing(object: object)
                    self.finishWork()
                }
//            }
//        }
    }
}
