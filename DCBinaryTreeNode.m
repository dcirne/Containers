//
//  DCBinaryTreeNode.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCBinaryTreeNode.h"

@implementation DCBinaryTreeNode

- (id)initWithObject:(id)object {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _object = object;
    _left = nil;
    _right = nil;
    
    return self;
}

@end
