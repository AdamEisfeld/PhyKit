//
//  NSValue+BLStructs.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "NSValue+CPHYStructs.h"
#import "CPHYStructs.h"

@implementation NSValue (BLAdditions)

+ (NSValue *)valueWithbkVector3:(struct PHYVector3)v {
    return [self valueWithBytes:&v objCType:@encode(struct PHYVector3)];
}

- (struct PHYVector3)bkVector3Value {
    struct PHYVector3 value;
    [self getValue:&value];
    return value;
}

@end

