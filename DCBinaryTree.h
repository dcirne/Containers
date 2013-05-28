//
//  DCBinaryTree.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCBinaryTreeNode;

@interface DCBinaryTree : NSObject

@property (nonatomic, strong) NSComparator comparator;
@property (nonatomic, strong, readonly) DCBinaryTreeNode *rootNode;

- (void)insert:(id)object;
- (void)remove:(DCBinaryTreeNode *)binaryTreeNode;
- (void)removeAllNodes;
- (DCBinaryTreeNode *)search:(id)object;

@end
