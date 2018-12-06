//
//  MoneyReceiver.swift
//  SecondProgramm
//
//  Created by Student on 24.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol MoneyReceiver {
    
    func receive(money: Int)
}

extension MoneyReceiver {
    
    func receiveMoney(from moneyGiver: MoneyGiver ) {
        self.receive(money: moneyGiver.giveMoney())
    }
}
