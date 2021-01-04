//
//  PKBGeometry.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBGeometry.h"
#import "PKBMesh.h"
#import "PKBPolygon.h"
#import "PKBVertex.h"
#import "PKBStructs.h"
#import "PKBGeometry+Internal.h"
#import "PKBCollisionShape.h"
#import "PKBCollisionShape+Internal.h"

#import "PKBDependencies+Internal.h"

@interface PKBGeometry ()

@end

@implementation PKBGeometry

- (instancetype)initWithMeshs: (NSArray <PKBMesh *> *)meshs {
    self = [super init];
    if (self) {
        _meshs = meshs;
    }
    return self;
}

@end
