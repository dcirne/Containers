//
//  DCTreeNode.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCTreeNode : NSObject

@property (nonatomic, strong) NSMutableSet *leafs;
@property (nonatomic, strong) id object;

- (id)initWithObject:(id)object;

@end
