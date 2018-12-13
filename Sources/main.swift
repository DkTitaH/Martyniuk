////
////  main.swift
////  SecondProgramm
////
////  Created by Student on 23.10.2018.
////  Copyright © 2018 Student. All rights reserved.
////
//
import Foundation

let runloop = RunLoop.current

let names = ["Fedor", "john", "coddy", "robert"]
let washers = names.map { Washer(name: $0) }

let accountant = Accountant(name: "George")
let director = Director(name: "Tony")

let carWashingService = Service(
    washers: washers,
    accountant: accountant,
    director: director
)

let car = Car(name: "car", money: 10)

let carFactory = CarFactory(carWash: carWashingService, queue: .background)
carFactory.start()

runloop.run()
