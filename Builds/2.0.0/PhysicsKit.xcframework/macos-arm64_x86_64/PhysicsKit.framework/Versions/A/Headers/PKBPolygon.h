//
//  PKBPolygon.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PKBVertex;

@interface PKBPolygon : NSObject

@property (nonatomic, readonly) NSArray <PKBVertex *>*vertices;

- (instancetype)initWithVertices: (NSArray <PKBVertex *>*)vertices;

@end

NS_ASSUME_NONNULL_END
