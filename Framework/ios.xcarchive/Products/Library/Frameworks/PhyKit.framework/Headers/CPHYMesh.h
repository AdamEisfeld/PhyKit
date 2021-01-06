//
//  CPHYMesh.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPHYPolygon;

@interface CPHYMesh : NSObject

@property (nonatomic, readonly) NSArray <CPHYPolygon *>*polygons;

- (instancetype)initWithPolygons: (NSArray <CPHYPolygon *>*)polygons;

@end

NS_ASSUME_NONNULL_END
