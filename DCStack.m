//
//  DCStack.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCStack.h"
#import "DCNode.h"
#import <dispatch/dispatch.h>

@interface DCStack() {
    DCNode *topNode;
    dispatch_queue_t queue;
}

@end


@implementation DCStack

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    queue = dispatch_queue_create("com.dalmocirne.Stack", DISPATCH_QUEUE_SERIAL);
    
    _empty = YES;
    _count = 0;
    _top = nil;
    
    return self;
}

- (void)push:(id)object {
    if (!object) {
        return;
    }
    
    dispatch_sync(queue, ^{
        DCNode *node = [[DCNode alloc] initWithObject:object];
        node.next = topNode;
        topNode = node;
        ++_count;
        _empty = NO;
        _top = object;
    });
}

- (id)pop {
    if (_empty) {
        return nil;
    }
    
    __block id object = nil;
    dispatch_sync(queue, ^{
        DCNode *node = topNode;
        topNode = topNode.next;
        node.next = nil;
        object = node.object;
        --_count;
        _empty = _count == 0;
        _top = topNode.object;
    });
    
    return object;
}

@end
