//
//  EmployeeManager.swift
//  CarWash
//
//  Created by Student on 20.12.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class EmployeeManager<ProcessingObject: MoneyGiver, Processor: Employee<ProcessingObject>>: ObservableObject<Processor> {
    
    private let processingQueue = Queue<ProcessingObject>()
    private let processors = Atomic([Processor]())
    private let observers = Atomic([Staff.Observer]())
    
    init(processors: [Processor]) {
        self.processors.value = processors
        super.init()
        self.initializeObservers()
    }
    
    func process(object: ProcessingObject) {
        self.processors.transform {
            let availableProcessor = $0.first{ $0.state == .available }
            if self.processingQueue.isEmpty {
                if let processor = availableProcessor {
                    if let object = processingQueue.dequeue() {
                        processor.asyncProcess(object: object)
                    } else {
                        processor.asyncProcess(object: object)
                    }
                } else {
                    self.processingQueue.enqueue(object)
                }
            } else {
                self.processingQueue.enqueue(object)
            }
        }
    }
    
    private func initializeObservers() {
        self.observers.value += self.processors.value.map { processor in
            let observers = processor.observer { [weak self, weak processor] state in
                DispatchQueue.background.async {
                    switch state {
                    case .waitingForProcessing:
                        processor.apply(self?.notify)
                    case .available:
                        self?.processingQueue.dequeue().apply(processor?.asyncProcess)
                    case .busy:
                        return
                    }
                }
            }
            
            return observers
        }
    }
}
