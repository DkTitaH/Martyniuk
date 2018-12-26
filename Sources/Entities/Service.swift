//
//  CarWash.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Service {
    
    private let washerManager: EmployeeManager<Car, Washer>
    private let accountantManager: EmployeeManager<Washer, Accountant>
    private let directorManager: EmployeeManager<Accountant, Director>
   
    private let canclellable = CompositCancellableProperty()
    
    private let cars = Queue<Car>()
    
    init(
        washers: [Washer],
        accountant: [Accountant],
        director: [Director]
    ) {
        self.accountantManager = EmployeeManager(processors: accountant)
        self.directorManager = EmployeeManager(processors: director)
        self.washerManager = EmployeeManager(processors: washers)
        self.initializeManagers()
    }
    
    func initializeManagers() {
        let accountantObserver = self.accountantManager.observer { accountant in
            self.directorManager.process(object: accountant)
        }
        
        let washerObserver = self.washerManager.observer { washer in
            self.accountantManager.process(object: washer)
        }
        
        self.canclellable.value = [accountantObserver, washerObserver]
    }
    
    func wash(car: Car) {
        self.washerManager.process(object: car)
    }
}
