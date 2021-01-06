//
//  CBKGeometry.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBKMesh;
@class CBKCollisionShape;

@interface CBKGeometry : NSObject

@property (nonatomic, readonly) NSArray <CBKMesh *> *meshs;

- (instancetype)initWithMeshs: (NSArray <CBKMesh *> *)meshs;

@end

NS_ASSUME_NONNULL_END
