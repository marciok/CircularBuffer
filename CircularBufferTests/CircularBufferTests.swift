//
//  CircularBufferTests.swift
//  CircularBufferTests
//
//  Created by Marcio Klepacz on 12/12/16.
//  Copyright © 2016 Marcio Klepacz. All rights reserved.
//

import XCTest
import CircularBuffer

class CircularBufferTests: XCTestCase {
    var buffer: CircularBuffer<Int>?
    
    override func setUp() {
        super.setUp()
        
        buffer = CircularBuffer<Int>(size: 4)
    }
    
    override func tearDown() {        
        super.tearDown()
        
        buffer = nil
    }
    
    func testRead(){
        _ = buffer!.write(18)
        let result = buffer!.read()
        
        XCTAssert(result! == 18)
    }
    
    func testWriteWhenIsNotFull() {
        _ = buffer!.write(1)
        _ = buffer!.write(2)
        _ = buffer!.write(4)
        let availableSpace = buffer!.write(3)
        
        XCTAssertTrue(availableSpace)
    }
    
    func testWriteWhenIsFull() {
        _ = buffer!.write(1)
        _ = buffer!.write(2)
        _ = buffer!.write(4)
        _ = buffer!.write(6)
        let availableSpace = buffer!.write(3)
        
        XCTAssertFalse(availableSpace)
    }
    
    func testReadWriteThreadSafe(){
        let writeTime = DispatchTime.now() + 2
        let assertTime = writeTime + 1
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: writeTime) {
            _ = self.buffer!.write(2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: writeTime) {
            _ = self.buffer!.write(2)
        }                
        
        DispatchQueue.main.asyncAfter(deadline: assertTime) {
            let first = self.buffer!.read()
            let second = self.buffer!.read()
            // The `sleep()` is needed in order to avoid false positives.
            // `sleep()` will make sure all operations are finished, before asserting.
            sleep(2) 
            
            XCTAssertNotNil(first)
            XCTAssert(first! == 2)
            XCTAssertNotNil(second)
        }
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 3))
    }
}
