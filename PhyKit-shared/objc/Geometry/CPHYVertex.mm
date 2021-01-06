//
//  CPHYVertex.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "CPHYVertex.h"
#import "CPHYStructs.h"

@implementation CPHYVertex

- (instancetype)initWithPosition: (struct PHYVector3)position {
    self = [super init];
    if (self) {
        _position = position;
    }
    return self;
}

@end
