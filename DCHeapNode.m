//
//  DCHeapNode.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 6/8/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCHeapNode.h"

@implementation DCHeapNode

- (id)initWithObject:(id)object parentNode:(DCHeapNode *)parentNode {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _object = object;
    _left = nil;
    _right = nil;
    [self setParent:parentNode];
    
    return self;
}

@end
