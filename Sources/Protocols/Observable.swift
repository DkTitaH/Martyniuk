//
//  Observeable.swift
//  CarWash
//
//  Created by Student on 05.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Observable {
    
    func attach(observer: Observer)
    
    func detach(forId: Int)
}
