//
//  PKBPolygon.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBPolygon.h"
#import "PKBVertex.h"

@implementation PKBPolygon

- (instancetype)initWithVertices: (NSArray <PKBVertex *>*)vertices {
    self = [super init];
    if (self) {
        _vertices = vertices;
    }
    return self;
}

@end
