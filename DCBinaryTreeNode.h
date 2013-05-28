//
//  DCBinaryTreeNode.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCBinaryTreeNode : NSObject

@property (nonatomic, strong) DCBinaryTreeNode *left;
@property (nonatomic, strong) DCBinaryTreeNode *right;
@property (nonatomic, strong) id object;

- (id)initWithObject:(id)object;

@end
