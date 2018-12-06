//
//  Queue.swift
//  CarWash
//
//  Created by Student on 30.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Queue<Element> {
    
    private let elements: Atomic<[Element]>
    
    var isEmpty: Bool {
        return self.elements.value.isEmpty
    }
    
    var count: Int {
        return self.elements.value.count
    }
    
    init(_ elements: [Element]) {
        self.elements = Atomic(elements)
    }

    convenience init() {
        self.init([Element]())
    }
    
    func enqueue(_ value: Element) {
        self.elements.modify {
            $0.append(value)
        }
    }
    
    func dequeue() -> Element? {
        return self.elements.modify {
            $0.safelyRemoveFirst()
        }
    }
}
