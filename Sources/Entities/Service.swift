//
//  CarWash.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Service: Observer {
    
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

    func handleWaitingEvent<ObservableObject>(sender: ObservableObject) {
        if sender is Accountant {
            self.director.asyncProcess(object: self.accountant)
        } else if let washer = sender as? Washer {
            self.accountant.asyncProcess(object: washer)
        }
    }
    
    func handleAvailableEvent<ObservableObject>(sender: ObservableObject) {
        if let washer = sender as? Washer {
            self.cars.dequeue().do(washer.asyncProcess)
        }
    }
    
    func handleBusyEvent<ObservableObject>(sender: ObservableObject) {
        
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
            washer.attach(observer: self)
        }
        self.accountant.attach(observer: self)
        self.director.attach(observer: self)
    }
}
