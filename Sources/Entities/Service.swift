//
//  CarWash.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Service {
    
    private var observers = Staff.Observers()
    
    private let accountant: Accountant
    private let director: Director
    private let washers: Atomic<[Washer]>
    
    private let cars = Queue<Car>()
    
    init(
        washers: [Washer],
        accountant: Accountant,
        director: Director
    ) {
        self.washers =  Atomic(washers)
        self.accountant = accountant
        self.director = director
        self.initializeObservers()
    }

    func wash(car: Car) {
        self.washers.transform {
            let availableWasher = $0.first{ $0.state == .available }
            
            if let washer = availableWasher {
                washer.asyncProcess(object: car)
            } else {
                self.cars.enqueue(car)
            }
        }
    }
    
    private func initializeObservers() {
        self.observers += self.washers.value.map { washer in
            let observers = washer.observer { [weak self, weak washer] state in
                switch state {
                case .waitingForProcessing:
                        washer.apply(self?.accountant.asyncProcess)
                case .available:
                    self?.cars.dequeue().apply(washer?.asyncProcess)
                case .busy:
                    return
                }
            }
            
            return observers
        }
    
        let accountantObserver = self.accountant.observer { [weak self] state in
            let accountant = self?.accountant
            switch state {
            case .waitingForProcessing:
                accountant.apply(self?.director.asyncProcess)
            case .busy:
                return
            case .available:
                return
            }
        }

        self.observers.append(observer: accountantObserver)
    }
}
