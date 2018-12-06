//
//  Factory.swift
//  CarWash
//
//  Created by Student on 07.11.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class CarFactory {
    
    var isRunning: Bool? {
        return self.token?.isRunning
    }
    
    private var token: DispatchQueue.CancellationToken? {
        willSet { self.token?.stop() }
    }

    private let carWash: Service
    private let carsCount = 10
    
    private let timeInterval = 5.0
    private let queue: DispatchQueue
    
    deinit {
        self.stop()
    }

    init(carWash: Service, queue: DispatchQueue) {
        self.carWash = carWash
        self.queue = queue
    }

    private func createCars() {
        self.carsCount.times {
            self.queue.async {
                self.carWash.wash(car: Car(name: "car", money: 10))
            }
        }
    }

    func start() {
        self.token = self.queue.timer(timeInterval: self.timeInterval) { [weak self] in
            self?.createCars()
        }
    }
    
    func stop() {
        self.token = nil
    }
}
