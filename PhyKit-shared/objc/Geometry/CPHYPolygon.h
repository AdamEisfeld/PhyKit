//
//  CPHYPolygon.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPHYVertex;

@interface CPHYPolygon : NSObject

@property (nonatomic, readonly) NSArray <CPHYVertex *>*vertices;

- (instancetype)initWithVertices: (NSArray <CPHYVertex *>*)vertices;

@end

NS_ASSUME_NONNULL_END
