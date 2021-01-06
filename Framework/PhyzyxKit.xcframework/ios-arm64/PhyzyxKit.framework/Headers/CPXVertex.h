//
//  CPXVertex.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PXVector3;

@interface CPXVertex : NSObject

@property (nonatomic, readonly) struct PXVector3 position;

- (instancetype)initWithPosition: (struct PXVector3)position;

@end

NS_ASSUME_NONNULL_END
