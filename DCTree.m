//
//  DCTree.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCTree.h"
#import "DCTreeNode.h"
#import "DCQueue.h"
#import <dispatch/dispatch.h>

@interface DCTree() {
    dispatch_queue_t queue;
    DCQueue *bfsQueue;
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

    for (DCTreeNode *childNode in treeNode.children) {
        [self removeTreeNode:childNode];
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
    
    DCTreeNode *resultTreeNode = nil;
    NSComparisonResult comparisonResult;
    if (self.comparator) {
        comparisonResult = self.comparator(object, treeNode.object);
    } else {
        comparisonResult = [object compare:treeNode.object];
    }
    
    if (comparisonResult == NSOrderedSame) {
        resultTreeNode = treeNode;
    } else {
        for (DCTreeNode *childNode in treeNode.children) {
            resultTreeNode = [self searchDepthFirst:object treeNode:childNode];
            if (resultTreeNode) {
                break;
            }
        }
    }
    
    return resultTreeNode;
}

- (DCTreeNode *)searchBreadthFirst:(id)object treeNode:(DCTreeNode *)treeNode {
    [bfsQueue enqueue:treeNode];
    
    DCTreeNode *resultTreeNode = nil, *searchTreeNode = nil;
    NSComparisonResult comparisonResult;
    while (!bfsQueue.empty) {
        searchTreeNode = [bfsQueue dequeue];
        
        if (self.comparator) {
            comparisonResult = self.comparator(object, searchTreeNode.object);
        } else {
            comparisonResult = [object compare:searchTreeNode.object];
        }
        
        if (comparisonResult == NSOrderedSame) {
            resultTreeNode = searchTreeNode;
            break;
        } else {
            for (DCTreeNode *childNode in searchTreeNode.children) {
                [bfsQueue enqueue:childNode];
            }
        }
    }
    
    return resultTreeNode;
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
        [insertionNode.children addObject:newNode];
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
                
            case SearchModeBreadthFirst: {
                bfsQueue = [[DCQueue alloc] init];
                treeNode = [self searchBreadthFirst:object treeNode:_rootNode];
                bfsQueue = nil;
            }
                break;
        }
    });
    
    return treeNode;
}

@end
