//
//  DCTree.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCTreeNode;
@class DCStack;

typedef enum SearchMode : NSUInteger {
    SearchModeDepthFirst = 0,
    SearchModeBreadthFirst
} SearchMode;

@interface DCTree : NSObject

@property (nonatomic, strong) NSComparator comparator;
@property (nonatomic, strong, readonly) DCTreeNode *rootNode;

- (void)insert:(id)object inTreeNode:(DCTreeNode *)treeNode;
- (void)remove:(DCTreeNode *)treeNode;
- (void)removeAllNodes;
- (DCTreeNode *)search:(id)object mode:(SearchMode)searchMode;
- (DCStack *)pathFrom:(DCTreeNode *)startNode to:(DCTreeNode *)endNode mode:(SearchMode)searchMode;

@end
