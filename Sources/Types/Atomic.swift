//
//  Atomic.swift
//  CarWash
//
//  Created by Student on 01.11.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

public class Atomic<Value> {
    
    public typealias ValueType = Value
    public typealias PropertyObserver = ((old: ValueType, new: ValueType)) -> ()
    
    public var value: ValueType {
        get { return self.transform { $0 } }
        set { self.modify { $0 = newValue } }
    }
    
    private var mutableValue: ValueType
    
    private let lock: NSLocking
    private let didSet: PropertyObserver?
    private let willSet: PropertyObserver?
    
    public init(
        _ value: ValueType,
        lock: NSRecursiveLock = NSRecursiveLock(),
        didSet: PropertyObserver? = nil,
        willSet: PropertyObserver? = nil
    ) {
        self.mutableValue = value
        self.lock = lock
        self.didSet = didSet
        self.willSet = willSet
    }
    
    @discardableResult
    public func modify<Result>(_ action: (inout ValueType) -> Result) -> Result {
        return self.lock.locked {
            let oldValue = self.mutableValue
            var newValue = self.mutableValue

            let result = action(&newValue)
            
            self.willSet?((old: oldValue, new: newValue))
            
            defer {
                self.didSet?((oldValue, self.mutableValue))
            }
            
            self.mutableValue = newValue
            
            return result
        }
    }
    
    public func transform<Result>(_ action: (ValueType) -> Result) -> Result {
        return self.lock.locked {
            action(self.mutableValue)
        }
    }
}
