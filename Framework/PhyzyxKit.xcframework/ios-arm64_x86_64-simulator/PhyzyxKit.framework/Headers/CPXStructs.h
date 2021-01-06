//
//  PXStructs.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

struct PXVector3 {
    float x;
    float y;
    float z;
};

struct PXVector4 {
    float x;
    float y;
    float z;
    float w;
};

struct PXQuaternion {
    float x;
    float y;
    float z;
    float w;
};

struct PXMatrix4 {

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

extern struct PXVector3 PXVector3Make(float x, float y, float z);
extern struct PXVector3 PXVector3MakeIdentity();

extern struct PXVector4 PXVector4Make(float x, float y, float z, float w);
extern struct PXVector4 PXVector4MakeIdentity();

extern struct PXQuaternion PXQuaternionMake(float x, float y, float z, float w);
extern struct PXQuaternion PXQuaternionMakeIdentity();

extern struct PXMatrix4 PXMatrix4Make(float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44);
extern struct PXMatrix4 PXMatrix4MakeIdentity();
extern struct PXVector3 PXVector3AxisFromQuaternion(struct PXQuaternion quaternion);

#ifdef __cplusplus
}
#endif


