//
//  Observer.swift
//  CarWash
//
//  Created by Student on 05.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Observer: class {
    
    var id: Int { get }
    
    func handleWaitingEvent<ObservableObject>(sender: ObservableObject)
    
    func handleAvailableEvent<ObservableObject>(sender: ObservableObject)
    
    func handleBusyEvent<ObservableObject>(sender: ObservableObject)
}
