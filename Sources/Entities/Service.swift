//
//  CarWash.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Service {
    
    var id = Int.random(in: 0...1000)
    
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
            washer.observer {
                switch $0 {
                case .waitingForProcessing:
                    self.accountant.asyncProcess(object: washer)
                case .available:
                    self.cars.dequeue().do(washer.asyncProcess)
                default:
                    return
                }
            }
        }

        self.accountant.observer {
            switch $0 {
            case .waitingForProcessing:
                 self.director.asyncProcess(object: self.accountant)
            case .available:
                self.accountant.continueWork()
            default:
                return
            }
        }

        self.director.observer {_ in

        }
    }
}
