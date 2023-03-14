//
//  Atomic.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.03.2023.
//

import Foundation

@propertyWrapper struct Atomic<Value> {
    
    // MARK: - Properties
    private var value: Value
    private let lock = NSLock()
    
    // MARK: - Init
    init(wrappedValue value: Value) {
        self.value = value
    }
    
    var wrappedValue: Value {
        get { read() }
        set { write(newValue: newValue) }
    }
    
    func read() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
    
    mutating func write(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}
