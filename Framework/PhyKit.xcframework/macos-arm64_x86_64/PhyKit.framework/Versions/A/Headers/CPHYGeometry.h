//
//  CPHYGeometry.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPHYMesh;
@class CPHYCollisionShape;

@interface CPHYGeometry : NSObject

@property (nonatomic, readonly) NSArray <CPHYMesh *> *meshs;

- (instancetype)initWithMeshs: (NSArray <CPHYMesh *> *)meshs;

@end

NS_ASSUME_NONNULL_END
