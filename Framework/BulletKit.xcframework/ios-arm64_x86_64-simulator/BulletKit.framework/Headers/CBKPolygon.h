//
//  CBKPolygon.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBKVertex;

@interface CBKPolygon : NSObject

@property (nonatomic, readonly) NSArray <CBKVertex *>*vertices;

- (instancetype)initWithVertices: (NSArray <CBKVertex *>*)vertices;

@end

NS_ASSUME_NONNULL_END
