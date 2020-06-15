//
//  PKBVertex.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBVertex.h"
#import "PKBStructs.h"

@implementation PKBVertex

- (instancetype)initWithPosition: (struct PKVector3)position {
    self = [super init];
    if (self) {
        _position = position;
    }
    return self;
}

@end
