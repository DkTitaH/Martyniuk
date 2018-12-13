//
//  Manager.swift
//  CarWash
//
//  Created by Student on 14.11.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Manager<Processed: MoneyGiver & Statable>: Employee<Processed> {
    
    override func completeProcessing(object: Processed) {
        object.state = .available
    }
}
