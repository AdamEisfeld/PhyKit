//
//  CPXMesh.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPXPolygon;

@interface CPXMesh : NSObject

@property (nonatomic, readonly) NSArray <CPXPolygon *>*polygons;

- (instancetype)initWithPolygons: (NSArray <CPXPolygon *>*)polygons;

@end

NS_ASSUME_NONNULL_END
