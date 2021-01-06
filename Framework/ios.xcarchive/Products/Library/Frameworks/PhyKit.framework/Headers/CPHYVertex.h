//
//  CPHYVertex.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PHYVector3;

@interface CPHYVertex : NSObject

@property (nonatomic, readonly) struct PHYVector3 position;

- (instancetype)initWithPosition: (struct PHYVector3)position;

@end

NS_ASSUME_NONNULL_END
