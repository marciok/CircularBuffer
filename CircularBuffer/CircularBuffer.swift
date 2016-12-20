//
//  CircularBuffer.swift
//  CircularBuffer
//
//  Created by Marcio Klepacz on 12/12/16.
//  Copyright © 2016 Marcio Klepacz. All rights reserved.
//

import Foundation

public struct CircularBuffer<T> {
    private var array: [T?]
    private var readIndex: Int32 = 0
    private var writeIndex: Int32 = 0
    
    public init(size: Int) {
        self.array = Array<T?>(repeatElement(nil, count: size))
    }
    
    public mutating func write(_ element: T) -> Bool {
        guard !isFull else { return false }
        
        let index = Int(writeIndex) % array.count
        array[index] = element
        atomic_increase(&writeIndex)
        
        return true
    }
    
    public mutating func read() -> T? {
        guard !array.isEmpty else { return nil }
        
        let index = Int(readIndex) % array.count
        let element = array[index]
        atomic_increase(&readIndex)
        
        return element
    }
    
    private var isFull: Bool {
        return writingSpace == 0
    }
    
    private var writingSpace: Int {
        return array.count - readingSpace
    }
    
    private var readingSpace: Int {
        return writeIndex - readIndex
    }
}
