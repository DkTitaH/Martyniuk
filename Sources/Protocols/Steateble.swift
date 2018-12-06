//
//  Steateble.swift
//  CarWash
//
//  Created by Student on 09.11.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Steateble: class {
    
    associatedtype Process: MoneyGiver
    
    var state: Employee<Process>.State { get set }
}
