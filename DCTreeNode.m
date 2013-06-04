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
    return [self initWithObject:object parent:nil];
}

- (id)initWithObject:(id)object parent:(DCTreeNode *)parent {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _object = object;
    _children = [[NSMutableSet alloc] initWithCapacity:1];
    _parent = parent;
    
    return self;
}

@end
