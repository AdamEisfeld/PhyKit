//
//  CBKMesh.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBKPolygon;

@interface CBKMesh : NSObject

@property (nonatomic, readonly) NSArray <CBKPolygon *>*polygons;

- (instancetype)initWithPolygons: (NSArray <CBKPolygon *>*)polygons;

@end

NS_ASSUME_NONNULL_END
