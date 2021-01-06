//
//  NSValue+BLStructs.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PXVector3;

@interface NSValue (BLAdditions)

+ (NSValue *)valueWithbkVector3:(struct PXVector3)v;

@property(nonatomic, readonly) struct PXVector3 bkVector3Value;


@end

NS_ASSUME_NONNULL_END
