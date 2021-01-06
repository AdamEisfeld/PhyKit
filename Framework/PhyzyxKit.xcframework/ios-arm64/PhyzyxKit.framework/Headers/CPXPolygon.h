//
//  CPXPolygon.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPXVertex;

@interface CPXPolygon : NSObject

@property (nonatomic, readonly) NSArray <CPXVertex *>*vertices;

- (instancetype)initWithVertices: (NSArray <CPXVertex *>*)vertices;

@end

NS_ASSUME_NONNULL_END
