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
                if newValue == .available {
                    state = .busy
                    self.processingQueue.dequeue().do(self.process)
                }
                state = newValue
                self.observers.notify(state: newValue)
            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    let name: String
    
    private let queue: DispatchQueue
    private let durationRange = 0.1...1.0
    
    private let processingQueue = Queue<ProcessingObject>()
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
        if let process = self.processingQueue.dequeue() {
            self.process(object: process)
        } else {
            self.state = .waitingForProcessing
        }
    }
    
    private func process(object: ProcessingObject) {
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationRange)) {
            self.performProcessing(object: object)
            self.completeProcessing(object: object)
            self.finishWork()
        }
    }
    
    func asyncProcess(object: ProcessingObject) {
        self.atomicState.modify {
            if $0 == .available {
    //the State setter is not called
                $0 = .busy
                self.process(object: object)
            } else {
                self.processingQueue.enqueue(object)
            }
        }
    }
}
