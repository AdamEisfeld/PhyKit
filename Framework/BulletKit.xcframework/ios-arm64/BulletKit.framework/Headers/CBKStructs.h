//
//  BKStructs.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

struct BKVector3 {
    float x;
    float y;
    float z;
};

struct BKVector4 {
    float x;
    float y;
    float z;
    float w;
};

struct BKQuaternion {
    float x;
    float y;
    float z;
    float w;
};

struct BKMatrix4 {

    float m11;
    float m12;
    float m13;
    float m14;
    float m21;
    float m22;
    float m23;
    float m24;
    float m31;
    float m32;
    float m33;
    float m34;
    float m41;
    float m42;
    float m43;
    float m44;
    
};

#ifdef __cplusplus
extern "C" {
#endif

extern struct BKVector3 BKVector3Make(float x, float y, float z);
extern struct BKVector3 BKVector3MakeIdentity();

extern struct BKVector4 BKVector4Make(float x, float y, float z, float w);
extern struct BKVector4 BKVector4MakeIdentity();

extern struct BKQuaternion BKQuaternionMake(float x, float y, float z, float w);
extern struct BKQuaternion BKQuaternionMakeIdentity();

extern struct BKMatrix4 BKMatrix4Make(float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44);
extern struct BKMatrix4 BKMatrix4MakeIdentity();
extern struct BKVector3 BKVector3AxisFromQuaternion(struct BKQuaternion quaternion);

#ifdef __cplusplus
}
#endif


