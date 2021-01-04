//
//  PKBMesh.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PKBPolygon;

@interface PKBMesh : NSObject

@property (nonatomic, readonly) NSArray <PKBPolygon *>*polygons;

- (instancetype)initWithPolygons: (NSArray <PKBPolygon *>*)polygons;

@end

NS_ASSUME_NONNULL_END
