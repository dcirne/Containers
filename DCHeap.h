//
//  DCHeap.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 6/8/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCContainerConstants.h"

@class DCHeapNode;

@interface DCHeap : NSObject

@property (nonatomic, strong) NSComparator comparator;
@property (nonatomic, strong, readonly) DCHeapNode *rootNode;

- (void)insert:(id)object;
- (void)remove:(DCHeapNode *)heapNode;
- (void)removeAllNodes;
- (DCHeapNode *)search:(id)object mode:(SearchMode)searchMode;

@end
