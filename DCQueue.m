//
//  DCQueue.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCQueue.h"
#import "DCNode.h"
#import <dispatch/dispatch.h>

@interface DCQueue() {
    DCNode *frontNode;
    DCNode *backNode;
    dispatch_queue_t queue;
}

@end


@implementation DCQueue

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    queue = dispatch_queue_create("com.dalmocirne.Queue", DISPATCH_QUEUE_SERIAL);
    
    _empty = YES;
    _count = 0;
    
    return self;
}

- (void)enqueue:(id)object {
    if (!object) {
        return;
    }
    
    dispatch_sync(queue, ^{
        DCNode *node = [[DCNode alloc] initWithObject:object];
        
        if (_empty) {
            _empty = NO;
            frontNode = node;
        } else {
            backNode.next = node;
        }
        
        backNode = node;
        
        ++_count;
    });
}

- (id)dequeue {
    if (_empty) {
        return nil;
    }
    
    __block id object = nil;
    dispatch_sync(queue, ^{
        DCNode *node = frontNode;
        object = node.object;
        frontNode = frontNode.next;
        node.next = nil;
        --_count;
        _empty = _count == 0;
    });
    
    return object;
}

@end
