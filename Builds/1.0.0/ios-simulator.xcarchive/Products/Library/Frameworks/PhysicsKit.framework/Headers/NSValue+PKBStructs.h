//
//  NSValue+BLStructs.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PKVector3;

@interface NSValue (BLAdditions)

+ (NSValue *)valueWithPKVector3:(struct PKVector3)v;

@property(nonatomic, readonly) struct PKVector3 PKVector3Value;


@end

NS_ASSUME_NONNULL_END
