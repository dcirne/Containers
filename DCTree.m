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
#import "DCStack.h"

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
    
    DCTreeNode *resultNode = nil;
    NSComparisonResult comparisonResult = self.comparator ? self.comparator(object, treeNode.object) : [object compare:treeNode.object];
    if (comparisonResult == NSOrderedSame) {
        resultNode = treeNode;
    } else {
        for (DCTreeNode *childNode in treeNode.children) {
            resultNode = [self searchDepthFirst:object treeNode:childNode];
            if (resultNode) {
                break;
            }
        }
    }
    
    return resultNode;
}

- (DCTreeNode *)searchBreadthFirst:(id)object treeNode:(DCTreeNode *)treeNode {
    DCQueue *bfsQueue = [[DCQueue alloc] init];
    [bfsQueue enqueue:treeNode];
    
    DCTreeNode *resultNode = nil, *searchNode = nil;
    NSComparisonResult comparisonResult;
    while (!bfsQueue.empty) {
        searchNode = [bfsQueue dequeue];
        
        comparisonResult = self.comparator ? self.comparator(object, searchNode.object) : [object compare:searchNode.object];
        if (comparisonResult == NSOrderedSame) {
            resultNode = searchNode;
            break;
        } else {
            for (DCTreeNode *childNode in searchNode.children) {
                [bfsQueue enqueue:childNode];
            }
        }
    }
    
    return resultNode;
}

- (BOOL)pathDepthFirstFrom:(DCTreeNode *)startNode to:(DCTreeNode *)endNode pathStack:(DCStack *)pathStack {
    BOOL endNodeFound = [startNode isEqual:endNode];
    
    if (!endNodeFound) {
        for (DCTreeNode *childNode in startNode.children) {
            [pathStack push:childNode];
            endNodeFound = [self pathDepthFirstFrom:childNode to:endNode pathStack:pathStack];
            
            if (endNodeFound) {
                break;
            } else {
                [pathStack pop];
            }
        }
    }
    
    return endNodeFound;
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
                
            case SearchModeBreadthFirst:
                treeNode = [self searchBreadthFirst:object treeNode:_rootNode];
                break;
        }
    });
    
    return treeNode;
}

- (DCStack *)pathFrom:(DCTreeNode *)startNode to:(DCTreeNode *)endNode mode:(SearchMode)searchMode {
    if (!startNode || !endNode) {
        return nil;
    }
    
    __block DCStack *resultStack = nil;
    __block DCStack *pathStack = [[DCStack alloc] init];
    dispatch_sync(queue, ^{
        switch (searchMode) {
            case SearchModeDepthFirst:
                [pathStack push:startNode];
                if ([self pathDepthFirstFrom:startNode to:endNode pathStack:pathStack]) {
                    resultStack = [[DCStack alloc] init];
                    while (!pathStack.empty) {
                        DCTreeNode *treeNode = [pathStack pop];
                        [resultStack push:treeNode];
                    }
                }
                break;
                
            case SearchModeBreadthFirst:
                break;
        }
    });
    
    return resultStack;
}

@end
