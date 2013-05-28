//
//  DCNode.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCNode.h"

@implementation DCNode

- (id)initWithObject:(id)object {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _object = object;
    _next = nil;
    
    return self;
}

@end
