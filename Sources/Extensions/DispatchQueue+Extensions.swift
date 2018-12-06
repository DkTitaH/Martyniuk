//
//  Extension.swift
//  SecondProgramm
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static var background = DispatchQueue.global(qos: .background)
    static var utility = DispatchQueue.global(qos: .utility)
    static var unspecified = DispatchQueue.global(qos: .unspecified)
    static var userInitiated = DispatchQueue.global(qos: .userInitiated)
    static var userInteractive = DispatchQueue.global(qos: .userInteractive)
    static var `default` = DispatchQueue.global(qos: .default)
}

extension DispatchQueue {
    
    class CancellationToken {

        var isRunning: Bool {
            return self.atomicRunning.value
        }
        
        let atomicRunning = Atomic(true)
        
        func stop() {
            self.atomicRunning.value = false
        }
    }
    
    func timer(timeInterval: TimeInterval, execute: @escaping F.Execute) -> CancellationToken {
        let token = CancellationToken()
        self.reiterate(timeInterval: timeInterval, token: token, execute: execute)
        
        return token
    }
    
    private func reiterate(
        timeInterval: TimeInterval,
        token: CancellationToken,
        execute: @escaping F.Execute
    ) {
        self.asyncAfter(deadline: .after(interval: timeInterval)) {
            if token.isRunning {
                execute()
                self.reiterate(timeInterval: timeInterval, token: token, execute: execute)
            }
        }
    }
}
