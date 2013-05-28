//
//  DCStack.h
//  DC Standard Library
//
//  Created by Dalmo Cirne on 5/28/13.
//  Copyright (c) 2013 Dalmo Cirne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCStack : NSObject

@property (nonatomic, readonly, weak) id top;
@property (nonatomic, readonly) BOOL empty;
@property (nonatomic, readonly, unsafe_unretained) NSUInteger count;

- (void)push:(id)object;
- (id)pop;

@end
