//
//  DCBinaryTree.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCBinaryTree.h"
#import "DCBinaryTreeNode.h"
#import <dispatch/dispatch.h>

@interface DCBinaryTree() {
    dispatch_queue_t queue;
}

@end


@implementation DCBinaryTree

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    queue = dispatch_queue_create("com.dalmocirne.BinaryTree", DISPATCH_QUEUE_SERIAL);
    _comparator = nil;
    _rootNode = nil;
    
    return self;
}

#pragma mark Private methods
- (void)insert:(id)object binaryTreeNode:(DCBinaryTreeNode *)binaryTreeNode {
    NSComparisonResult comparisonResult;
    
    if (self.comparator) {
        comparisonResult = self.comparator(object, binaryTreeNode.object);
    } else {
        comparisonResult = [object compare:binaryTreeNode.object];
    }
    
    if (comparisonResult == NSOrderedAscending) {
        if (binaryTreeNode.left) {
            [self insert:object binaryTreeNode:binaryTreeNode.left];
        } else {
            binaryTreeNode.left = [[DCBinaryTreeNode alloc] initWithObject:object];
        }
    } else {
        if (binaryTreeNode.right) {
            [self insert:object binaryTreeNode:binaryTreeNode.right];
        } else {
            binaryTreeNode.right = [[DCBinaryTreeNode alloc] initWithObject:object];
        }
    }
}

- (void)removeBinaryTreeNode:(DCBinaryTreeNode *)binaryTreeNode {
    if (!binaryTreeNode) {
        return;
    }
    
    BOOL removeRootNode = [binaryTreeNode isEqual:_rootNode];
    
    [self removeBinaryTreeNode:binaryTreeNode.left];
    [self removeBinaryTreeNode:binaryTreeNode.right];

    if (removeRootNode) {
        _rootNode = nil;
    }
    
    [binaryTreeNode setObject:nil];
    binaryTreeNode = nil;
}

- (DCBinaryTreeNode *)search:(id)object binaryTreeNode:(DCBinaryTreeNode *)binaryTreeNode {
    if (!binaryTreeNode) {
        return nil;
    }
    
    NSComparisonResult comparisonResult;
    if (self.comparator) {
        comparisonResult = self.comparator(object, binaryTreeNode.object);
    } else {
        comparisonResult = [object compare:binaryTreeNode.object];
    }
    
    DCBinaryTreeNode *searchBinaryTreeNode;
    switch (comparisonResult) {
        case NSOrderedSame:
            searchBinaryTreeNode = binaryTreeNode;
            break;
            
        case NSOrderedAscending:
            searchBinaryTreeNode = [self search:object binaryTreeNode:binaryTreeNode.left];
            break;
            
        case NSOrderedDescending:
            searchBinaryTreeNode = [self search:object binaryTreeNode:binaryTreeNode.right];
            break;
            
        default:
            searchBinaryTreeNode = nil;
            break;
    }
    
    return searchBinaryTreeNode;
}

#pragma mark Public methods
- (void)insert:(id)object {
    if (!object) {
        return;
    }
    
    dispatch_sync(queue, ^{
        if (_rootNode) {
            [self insert:object binaryTreeNode:_rootNode];
        } else {
            _rootNode = [[DCBinaryTreeNode alloc] initWithObject:object];
        }
    });
}

- (void)remove:(DCBinaryTreeNode *)binaryTreeNode {
    if (!binaryTreeNode) {
        return;
    }
    
    dispatch_sync(queue, ^{
        [self removeBinaryTreeNode:binaryTreeNode];
    });
}

- (void)removeAllNodes {
    if (!_rootNode) {
        return;
    }
    
    dispatch_sync(queue, ^{
        [self removeBinaryTreeNode:_rootNode];
    });
}

- (DCBinaryTreeNode *)search:(id)object {
    if (!object) {
        return nil;
    }
    
    __block DCBinaryTreeNode *binaryTreeNode = nil;
    dispatch_sync(queue, ^{
        binaryTreeNode = [self search:object binaryTreeNode:_rootNode];
    });
    
    return binaryTreeNode;
}

@end
