//
//  CPHYGeometry.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "CPHYGeometry.h"
#import "CPHYMesh.h"
#import "CPHYPolygon.h"
#import "CPHYVertex.h"
#import "CPHYStructs.h"
#import "CPHYGeometry+Internal.h"
#import "CPHYCollisionShape.h"
#import "CPHYCollisionShape+Internal.h"

#import "CPHYDependencies+Internal.h"

@interface CPHYGeometry ()

@end

@implementation CPHYGeometry

- (instancetype)initWithMeshs: (NSArray <CPHYMesh *> *)meshs {
    self = [super init];
    if (self) {
        _meshs = meshs;
    }
    return self;
}

@end
