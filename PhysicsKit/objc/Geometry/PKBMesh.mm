//
//  PKBMesh.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBMesh.h"
#import "PKBPolygon.h"

@implementation PKBMesh

- (instancetype)initWithPolygons: (NSArray <PKBPolygon *>*)polygons {
    self = [super init];
    if (self) {
        _polygons = polygons;
    }
    return self;
}

@end
