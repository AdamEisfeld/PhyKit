//
//  PHYStructs.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

struct PHYVector3 {
    float x;
    float y;
    float z;
};

struct PHYVector4 {
    float x;
    float y;
    float z;
    float w;
};

struct PHYQuaternion {
    float x;
    float y;
    float z;
    float w;
};

struct PHYMatrix4 {

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

extern struct PHYVector3 PHYVector3Make(float x, float y, float z);
extern struct PHYVector3 PHYVector3MakeIdentity();

extern struct PHYVector4 PHYVector4Make(float x, float y, float z, float w);
extern struct PHYVector4 PHYVector4MakeIdentity();

extern struct PHYQuaternion PHYQuaternionMake(float x, float y, float z, float w);
extern struct PHYQuaternion PHYQuaternionMakeIdentity();

extern struct PHYMatrix4 PHYMatrix4Make(float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44);
extern struct PHYMatrix4 PHYMatrix4MakeIdentity();
extern struct PHYVector3 PHYVector3AxisFromQuaternion(struct PHYQuaternion quaternion);

#ifdef __cplusplus
}
#endif


