//
//  CarWash.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Service {
    
    private let accountant: Accountant
    private let director: Director
    private let washers: Atomic<[Washer]>
    
    private let cars = Queue<Car>()
    private var observers = [Observer]()

    deinit {
        
    }
    
    init(
        washers: [Washer],
        accountant: Accountant,
        director: Director
    ) {
        self.washers =  Atomic(washers)
        self.accountant = accountant
        self.director = director
        self.initializeObserver()
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
    
    private func initializeObserver() {
        
        self.washers.value.forEach { washer in
        let washerObserver = washer.observer { [weak self, weak washer] in
                switch $0 {
                case .waitingForProcessing:
                    washer.apply(self?.accountant.asyncProcess)
                case .available:
                    self?.cars.dequeue().apply(washer?.asyncProcess)
                default:
                    return
                }
            }
            self.observers.append(washerObserver)
        }

        let accountantObserver = self.accountant.observer { [weak self] in
            let accountant = self?.accountant
            switch $0 {
            case .waitingForProcessing:
                 accountant.apply(self?.director.asyncProcess)
            case .available:
                self?.accountant.continueWork()
            default: return
            }
        }
        self.observers.append(accountantObserver)

        let directorObserver = self.director.observer {_ in

        }
        self.observers.append(directorObserver)
    }
}
