//
//  PKBGeometry.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PKBMesh;
@class PKBCollisionShape;

@interface PKBGeometry : NSObject

@property (nonatomic, readonly) NSArray <PKBMesh *> *meshs;

- (instancetype)initWithMeshs: (NSArray <PKBMesh *> *)meshs;

@end

NS_ASSUME_NONNULL_END
