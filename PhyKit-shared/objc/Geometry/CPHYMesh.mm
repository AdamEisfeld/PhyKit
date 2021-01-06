//
//  CPHYMesh.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#import "CPHYMesh.h"
#import "CPHYPolygon.h"

@implementation CPHYMesh

- (instancetype)initWithPolygons: (NSArray <CPHYPolygon *>*)polygons {
    self = [super init];
    if (self) {
        _polygons = polygons;
    }
    return self;
}

@end
