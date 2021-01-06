//
//  CPXGeometry.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPXMesh;
@class CPXCollisionShape;

@interface CPXGeometry : NSObject

@property (nonatomic, readonly) NSArray <CPXMesh *> *meshs;

- (instancetype)initWithMeshs: (NSArray <CPXMesh *> *)meshs;

@end

NS_ASSUME_NONNULL_END
