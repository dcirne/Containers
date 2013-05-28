//
//  DCTreeNode.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCTreeNode.h"

@implementation DCTreeNode

- (id)initWithObject:(id)object {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _object = object;
    _leafs = [[NSMutableSet alloc] initWithCapacity:1];
    
    return self;
}

@end
