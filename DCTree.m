//
//  DCTree.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCTree.h"
#import "DCTreeNode.h"
#import <dispatch/dispatch.h>

@interface DCTree() {
    dispatch_queue_t queue;
}

@end


@implementation DCTree

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    queue = dispatch_queue_create("com.dalmocirne.Tree", DISPATCH_QUEUE_SERIAL);
    _comparator = nil;
    _rootNode = nil;
    
    return self;
}

#pragma mark Private methods
- (void)removeTreeNode:(DCTreeNode *)treeNode {
    if (!treeNode) {
        return;
    }

    BOOL removeRootNode = [treeNode isEqual:_rootNode];

    for (DCTreeNode *leafNode in treeNode.leafs) {
        [self removeTreeNode:leafNode];
    }
    
    if (removeRootNode) {
        _rootNode = nil;
    }
    
    [treeNode setObject:nil];
    treeNode = nil;
}

- (DCTreeNode *)searchDepthFirst:(id)object treeNode:(DCTreeNode *)treeNode {
    if (!treeNode) {
        return nil;
    }
    
    DCTreeNode *searchTreeNode = nil;
    NSComparisonResult comparisonResult;
    if (self.comparator) {
        comparisonResult = self.comparator(object, treeNode.object);
        
        if (comparisonResult == NSOrderedSame) {
            searchTreeNode = treeNode;
        } else {
            for (DCTreeNode *leafNode in treeNode.leafs) {
                searchTreeNode = [self searchDepthFirst:object treeNode:leafNode];
                if (searchTreeNode) {
                    break;
                }
            }
        }
        
        return searchTreeNode;
    } else {
        for (DCTreeNode *leafNode in treeNode.leafs) {
            comparisonResult = [object compare:leafNode.object];
        }
    }
    
    return nil;
}

- (DCTreeNode *)searchBreadthFirst:(id)object {
    return nil;
}

#pragma mark Public methods
- (void)insert:(id)object inTreeNode:(DCTreeNode *)treeNode {
    if (!object) {
        return;
    }
    
    dispatch_sync(queue, ^{
        if (!_rootNode) {
            _rootNode = [[DCTreeNode alloc] initWithObject:object];
            return;
        }
        
        DCTreeNode *insertionNode = treeNode ? : _rootNode;
        DCTreeNode *newNode = [[DCTreeNode alloc] initWithObject:object];
        [insertionNode.leafs addObject:newNode];
    });
}

- (void)remove:(DCTreeNode *)treeNode {
    if (!treeNode) {
        return;
    }
    
    dispatch_sync(queue, ^{
        [self removeTreeNode:treeNode];
    });
}

- (void)removeAllNodes {
    if (!_rootNode) {
        return;
    }
    
    dispatch_sync(queue, ^{
        [self removeTreeNode:_rootNode];
    });
}

- (DCTreeNode *)search:(id)object mode:(SearchMode)searchMode {
    if (!object) {
        return nil;
    }
    
    __block DCTreeNode *treeNode = nil;
    dispatch_sync(queue, ^{
        switch (searchMode) {
            case SearchModeDepthFirst:
                treeNode = [self searchDepthFirst:object treeNode:_rootNode];
                break;
                
            case SearchModeBreadthFirst:
                treeNode = [self searchBreadthFirst:object];
                break;
        }
    });
    
    return treeNode;
}

@end
