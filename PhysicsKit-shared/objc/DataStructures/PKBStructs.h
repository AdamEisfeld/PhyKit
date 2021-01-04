//
//  BLStructs.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

struct PKVector3 {
    float x;
    float y;
    float z;
};

struct PKVector4 {
    float x;
    float y;
    float z;
    float w;
};

struct PKQuaternion {
    float x;
    float y;
    float z;
    float w;
};

struct PKMatrix4 {

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

extern struct PKVector3 PKVector3Make(float x, float y, float z);
extern struct PKVector3 PKVector3MakeIdentity();

extern struct PKVector4 PKVector4Make(float x, float y, float z, float w);
extern struct PKVector4 PKVector4MakeIdentity();

extern struct PKQuaternion PKQuaternionMake(float x, float y, float z, float w);
extern struct PKQuaternion PKQuaternionMakeIdentity();

extern struct PKMatrix4 PKMatrix4Make(float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44);
extern struct PKMatrix4 PKMatrix4MakeIdentity();
extern struct PKVector3 PKVector3AxisFromQuaternion(struct PKQuaternion quaternion);

#ifdef __cplusplus
}
#endif


