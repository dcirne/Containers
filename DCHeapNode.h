//
//  DCHeapNode.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 6/8/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCHeapNode : NSObject

@property (nonatomic, strong) DCHeapNode *left;
@property (nonatomic, strong) DCHeapNode *right;
@property (nonatomic, weak) DCHeapNode *parent;
@property (nonatomic, strong) id object;

- (id)initWithObject:(id)object parentNode:(DCHeapNode *)parentNode;

@end
