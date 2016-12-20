//
//  atomic_operations.c
//  CircularBuffer
//
//  Created by Marcio Klepacz on 12/14/16.
//  Copyright © 2016 Marcio Klepacz. All rights reserved.
//

#include "atomic_operations.h"
#include <stdatomic.h>

void atomic_increase(int* count) {
    atomic_int atomic_count = *count;
    atomic_fetch_add_explicit(&atomic_count, 1, memory_order_relaxed);
    
    *count += atomic_count;
}
