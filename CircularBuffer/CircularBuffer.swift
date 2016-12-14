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
    private var readIndex = 0
    private var writeIndex = 0
    
    // Warning: do not call `readAndWriteQueue` inside another `readAndWriteQueue` it will create a deadlock.
    private let readAndWriteQueue = DispatchQueue(label: "com.marcioklepacz.CircularBuffer.readWriteQueue")
    
    public init(size: Int) {
        self.array = Array<T?>(repeatElement(nil, count: size))
    }
    
    public mutating func write(_ element: T) -> Bool {
        var wrote = false
        
        readAndWriteQueue.sync {
            guard !isFull else { return }
            array[writeIndex % array.count] = element
            writeIndex += 1
            wrote = true
        }
        
        return wrote
    }
    
    public mutating func read() -> T? {
        var element: T? = nil
        
        readAndWriteQueue.sync {
            guard !array.isEmpty else { return }
            element = array[readIndex % array.count]
            readIndex += 1
        }
        
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
