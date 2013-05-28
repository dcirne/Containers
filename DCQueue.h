//
//  DCQueue.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCQueue : NSObject

@property (nonatomic, readonly) BOOL empty;
@property (nonatomic, readonly, unsafe_unretained) NSUInteger count;

- (void)enqueue:(id)object;
- (id)dequeue;

@end
