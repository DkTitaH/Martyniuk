//
//  Staff.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Employee<ProcessingObject: MoneyGiver>: MoneyReceiver, MoneyGiver, Steateble, Observable {
    
    enum State {
        case busy
        case waitingForProcessing
        case available
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            for (identifier, weakObserver) in observers {
                if let observer = weakObserver {
                    self.atomicState.value = newValue
                    
                    switch newValue {
                    case .waitingForProcessing:
                        observer.handleWaitingEvent(sender: self)
                    case .available:
                        observer.handleAvailableEvent(sender: self)
                        self.processQueue.dequeue().do(self.asyncProcess)
                    case .busy:
                        observer.handleBusyEvent(sender: self)
                    }
                } else {
                    self.detach(forId: identifier)
                }
            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    var observers =  [Int : Observer?]()
    
    let name: String
    let atomicState = Atomic(State.available)
    
    private let processQueue = Queue<ProcessingObject>()
    private let atomicMoney = Atomic(0)
    
    private let queue: DispatchQueue
    private let durationRange = 0.1...1.0
    
    init(name: String, queue: DispatchQueue) {
        self.name = name
        self.queue = queue
    }
    
    weak var observer: Observer?
    
    func attach(observer: Observer) {
        self.observer = observer
        if let weakObserver = self.observer {
            self.observers.updateValue(weakObserver, forKey: observer.id)
        }
    }
    
    func detach(forId: Int) {
        self.observers.removeValue(forKey: forId)
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
        if let process = self.processQueue.dequeue() {
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
                $0 = .busy
                self.process(object: object)
            } else {
                self.processQueue.enqueue(object)
            }
        }
    }
}
