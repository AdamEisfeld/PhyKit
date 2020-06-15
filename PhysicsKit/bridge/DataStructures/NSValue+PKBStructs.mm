//
//  NSValue+BLStructs.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "NSValue+PKBStructs.h"
#import "PKBStructs.h"

@implementation NSValue (BLAdditions)

+ (NSValue *)valueWithPKVector3:(struct PKVector3)v {
    return [self valueWithBytes:&v objCType:@encode(struct PKVector3)];
}

- (struct PKVector3)PKVector3Value {
    struct PKVector3 value;
    [self getValue:&value];
    return value;
}

@end

