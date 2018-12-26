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
    private let cancellableObservers = CompositCancellableProperty()
    
    init(processors: [Processor]) {
        self.processors.value = processors
        super.init()
        self.initializeObservers()
    }
    
    func process(object: ProcessingObject) {
        self.processingQueue.enqueue(object)
        self.processors.transform {
            let availableProcessor = $0.first{ $0.state == .available }
            if let processor = availableProcessor {
                if let object = self.processingQueue.dequeue() {
                    processor.asyncProcess(object: object)
                }
            }
        }
    }
    
    private func initializeObservers() {
        self.cancellableObservers.value = self.processors.value.map { processor in
            let observers = processor.observer { [weak self, weak processor] state in
                switch state {
                case .waitingForProcessing:
                    processor.apply(self?.notify)
                case .available:
                    self?.processingQueue.dequeue().apply(processor?.asyncProcess)
                case .busy:
                    return
                }
            }
            
            return observers
        }
    }
}
