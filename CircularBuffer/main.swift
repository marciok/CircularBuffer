//
//  main.swift
//  CircularBuffer
//
//  Created by Marcio Klepacz on 12/12/16.
//  Copyright © 2016 Marcio Klepacz. All rights reserved.
//

import Foundation

var buffer = CircularBuffer<Int>(size: 10)

for i in 0...20 {
    DispatchQueue.global(qos: .background).async {
        _ = buffer.write(i)
    }
    
    DispatchQueue.global().async {
        print(buffer.read() ?? "")
    }
}

RunLoop.current.run(until: Date(timeIntervalSinceNow: 5))
