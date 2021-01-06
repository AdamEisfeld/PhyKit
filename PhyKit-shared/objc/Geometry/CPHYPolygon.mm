//
//  CPHYPolygon.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "CPHYPolygon.h"
#import "CPHYVertex.h"

@implementation CPHYPolygon

- (instancetype)initWithVertices: (NSArray <CPHYVertex *>*)vertices {
    self = [super init];
    if (self) {
        _vertices = vertices;
    }
    return self;
}

@end
