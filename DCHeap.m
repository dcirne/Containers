//
//  DCHeap.m
//  DC Standard Library
//
//  Created by Dalmo Cirne on 6/8/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import "DCHeap.h"
#import "DCHeapNode.h"
#import <dispatch/dispatch.h>
#import "DCQueue.h"

@interface DCHeap() {
    dispatch_queue_t queue;
    __weak DCHeapNode *nextLeaf;
}

@end


@implementation DCHeap

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    queue = dispatch_queue_create("com.dalmocirne.Heap", DISPATCH_QUEUE_SERIAL);
    _comparator = nil;
    _rootNode = nil;
    nextLeaf = nil;
    
    return self;
}

#pragma mark Private methods
- (void)insert:(id)object heapNode:(DCHeapNode *)heapNode {
    DCQueue *bfsQueue = [[DCQueue alloc] init];
    [bfsQueue enqueue:heapNode];
    
    DCHeapNode *searchNode, *newNode = nil;
    BOOL objectInserted = NO;
    while (!bfsQueue.empty && !objectInserted) {
        searchNode = [bfsQueue dequeue];
        
        if (!searchNode.left || !searchNode.right) {
            newNode = [[DCHeapNode alloc] initWithObject:object parentNode:searchNode];
            objectInserted = YES;
            
            if (!searchNode.left) {
                searchNode.left = newNode;
            } else {
                searchNode.right = newNode;
            }
        } else {
            [bfsQueue enqueue:searchNode.left];
            [bfsQueue enqueue:searchNode.right];
        }
        
        if (objectInserted) {
            NSComparisonResult comparisonResult = self.comparator ? self.comparator(object, searchNode.object) : [object compare:searchNode.object];
            if (comparisonResult != NSOrderedSame) {
                [self swapParentChildNodes:newNode];
            }
        }
    }
}

- (void)removeHeapNode:(DCHeapNode *)heapNode {
    DCHeapNode *parentNode = heapNode.parent;
    DCHeapNode *leftNode = heapNode.left;
    DCHeapNode *rightNode = heapNode.right;
 
    DCQueue *bfsQueue = [[DCQueue alloc] init];
    [bfsQueue enqueue:heapNode];
    DCHeapNode *searchNode, *rightmostLeafNode = nil;
    while (!bfsQueue.empty) {
        searchNode = [bfsQueue dequeue];
        
        if (bfsQueue.empty) {
            rightmostLeafNode = searchNode;
        }
    }
    
    if (rightmostLeafNode == rightmostLeafNode.parent.left) {
        rightmostLeafNode.parent.left = nil;
    } else {
        rightmostLeafNode.parent.right = nil;
    }
    
    rightmostLeafNode.parent = parentNode;
    rightmostLeafNode.left = leftNode;
    rightmostLeafNode.right = rightNode;
    
    if (parentNode.left == heapNode) {
        parentNode.left = rightmostLeafNode;
    } else {
        parentNode.right = rightmostLeafNode;
    }
    
    leftNode.parent = rightmostLeafNode;
    rightNode.parent = rightmostLeafNode;
    
    NSComparisonResult comparisonResult = self.comparator ? self.comparator(leftNode.object, rightNode.object) : [leftNode.object compare:rightNode.object];
    DCHeapNode *largerChildNode = comparisonResult == NSOrderedAscending ? rightNode : leftNode;
    comparisonResult = self.comparator ? self.comparator(rightmostLeafNode.object, largerChildNode.object) : [rightmostLeafNode.object compare:largerChildNode.object];
    if (comparisonResult == NSOrderedDescending) {
        [self swapParentChildNodes:largerChildNode];
    }
}

- (DCHeapNode *)searchBreadthFirst:(id)object heapNode:(DCHeapNode *)heapNode {
    DCQueue *bfsQueue = [[DCQueue alloc] init];
    [bfsQueue enqueue:heapNode];
    
    DCHeapNode *searchNode, *resultNode = nil;
    NSComparisonResult comparisonResult;
    while (!bfsQueue.empty) {
        searchNode = [bfsQueue dequeue];
        
        comparisonResult = self.comparator ? self.comparator(object, searchNode.object) : [object compare:searchNode.object];
        if (comparisonResult == NSOrderedSame) {
            resultNode = searchNode;
            break;
        }
    }

    return resultNode;
}

- (DCHeapNode *)searchDepthFirst:(id)object heapNode:(DCHeapNode *)heapNode {
    if (!heapNode) {
        return nil;
    }
    
    DCHeapNode *resultNode = nil;
    NSComparisonResult comparisonResult = self.comparator ? self.comparator(object, heapNode.object) : [object compare:heapNode.object];
    if (comparisonResult == NSOrderedSame) {
        resultNode = heapNode;
    } else {
        resultNode = [self searchDepthFirst:object heapNode:heapNode.left];
        if (!resultNode) {
            resultNode = [self searchDepthFirst:object heapNode:heapNode.right];
        }
    }
    
    return resultNode;
}

- (void)swapParentChildNodes:(DCHeapNode *)childNode {
    DCHeapNode *parentNode = childNode.parent;
    DCHeapNode *grandParentNode = childNode.parent.parent;
    DCHeapNode *leftNode = childNode.left;
    DCHeapNode *rightNode = childNode.right;
    
    if (grandParentNode.left == parentNode) {
        grandParentNode.left = childNode;
    } else {
        grandParentNode.right = childNode;
    }
    
    if (parentNode.left == childNode) {
        childNode.right = parentNode.right;
        childNode.left = parentNode;
    } else {
        childNode.left = parentNode.left;
        childNode.right = parentNode;
    }
    
    parentNode.left = leftNode;
    leftNode.parent = parentNode;
    parentNode.right = rightNode;
    rightNode.parent = parentNode;
    
    NSComparisonResult comparisonResult = self.comparator ? self.comparator(childNode.object, grandParentNode.object) : [childNode.object compare:grandParentNode.object];
    if (comparisonResult != NSOrderedSame) {
        [self swapParentChildNodes:childNode];
    }
}

#pragma mark Public methods
- (void)insert:(id)object {
    if (!object) {
        return;
    }
    
    dispatch_sync(queue, ^{
        if (_rootNode) {
            [self insert:object heapNode:_rootNode];
        } else {
            _rootNode = [[DCHeapNode alloc] initWithObject:object parentNode:nil];
            nextLeaf = _rootNode.left;
        }
    });
}

- (void)remove:(DCHeapNode *)heapNode {
    if (!heapNode) {
        return;
    }
    
    dispatch_sync(queue, ^{
        [self removeHeapNode:heapNode];
    });
}

- (void)removeAllNodes {
    if (!_rootNode) {
        return;
    }
    
    dispatch_sync(queue, ^{
        [self removeHeapNode:_rootNode];
    });
}

- (DCHeapNode *)search:(id)object mode:(SearchMode)searchMode {
    if (!object) {
        return nil;
    }
    
    __block DCHeapNode *heapNode = nil;
    dispatch_sync(queue, ^{
        switch (searchMode) {
            case SearchModeBreadthFirst:
                heapNode = [self searchBreadthFirst:object heapNode:_rootNode];
                break;
                
            case SearchModeDepthFirst:
                heapNode = [self searchDepthFirst:object heapNode:_rootNode];
                break;
        }
    });
    
    return heapNode;
}

@end
